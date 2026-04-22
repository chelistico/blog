#!/bin/bash

# 🔧 Comandos de Debug para HTTP 403 en Livewire
# Uso: bash COMANDOS_DEBUG_CSRF.sh [comando]

set -e

PROJECT_PATH="/var/www/html/blog/backend"
LOG_FILE="$PROJECT_PATH/storage/logs/laravel.log"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Comando 1: Verificar configuración
check_config() {
    print_header "1. Verificando Configuración"
    
    echo ""
    echo "SESSION_DRIVER:"
    grep "SESSION_DRIVER" $PROJECT_PATH/.env.production || echo "NO ENCONTRADO"
    
    echo ""
    echo "SESSION_DOMAIN:"
    grep "SESSION_DOMAIN" $PROJECT_PATH/.env.production || echo "NO ENCONTRADO"
    
    echo ""
    echo "SESSION_SAME_SITE:"
    grep "SESSION_SAME_SITE" $PROJECT_PATH/.env.production || echo "NO ENCONTRADO"
    
    echo ""
    echo "SESSION_SECURE_COOKIE:"
    grep "SESSION_SECURE_COOKIE" $PROJECT_PATH/.env.production || echo "NO ENCONTRADO"
    
    echo ""
    echo "SANCTUM_STATEFUL_DOMAINS:"
    grep "SANCTUM_STATEFUL_DOMAINS" $PROJECT_PATH/.env.production || echo "NO ENCONTRADO"
    
    echo ""
    echo "CORS_ALLOWED_ORIGINS:"
    grep "CORS_ALLOWED_ORIGINS" $PROJECT_PATH/.env.production || echo "NO ENCONTRADO"
}

# Comando 2: Verificar tabla de sesiones
check_sessions_table() {
    print_header "2. Verificando Tabla de Sesiones en BD"
    
    cd $PROJECT_PATH
    
    php artisan tinker << 'TINKER'
echo "=== Session Table Info ===\n";
try {
    $count = DB::table('sessions')->count();
    echo "✅ Tabla sessions existe\n";
    echo "   Registros activos: $count\n";
    
    $recent = DB::table('sessions')->latest('last_activity')->first();
    if ($recent) {
        echo "\n=== Sesión Más Reciente ===\n";
        echo "ID: " . $recent->id . "\n";
        echo "User ID: " . $recent->user_id . "\n";
        echo "IP: " . $recent->ip_address . "\n";
        echo "Last Activity: " . $recent->last_activity . "\n";
    }
} catch (Exception $e) {
    echo "❌ Error al acceder a tabla sessions:\n";
    echo "   " . $e->getMessage() . "\n";
    echo "   Solución: php artisan session:table && php artisan migrate\n";
}
exit;
TINKER
}

# Comando 3: Verificar logs de errores
check_logs() {
    print_header "3. Últimos Errores en Logs"
    
    echo ""
    echo "Buscando errores CSRF/403:"
    grep -i "csrf\|token.*mismatch\|403.*forbidden" $LOG_FILE | tail -10 || {
        echo "No se encontraron errores de CSRF/403"
    }
    
    echo ""
    echo "Últimas excepciones:"
    grep "Exception\|Error" $LOG_FILE | tail -10 || {
        echo "No se encontraron excepciones"
    }
}

# Comando 4: Limpiar sesiones y caches
clean_all() {
    print_header "4. Limpiando Sesiones y Caches"
    
    cd $PROJECT_PATH
    
    print_warning "Ejecutando limpieza..."
    
    php artisan session:clean
    print_success "Sesiones limpias"
    
    php artisan cache:clear
    print_success "Cache limpiado"
    
    php artisan config:cache
    print_success "Configuración recacheada"
    
    php artisan view:clear
    print_success "Vistas limpiadas"
    
    echo ""
    print_warning "Reiniciando PHP-FPM..."
    sudo systemctl restart php-fpm
    
    if sudo systemctl is-active --quiet php-fpm; then
        print_success "PHP-FPM reiniciado exitosamente"
    else
        print_error "Error reiniciando PHP-FPM"
        return 1
    fi
}

# Comando 5: Diagnostico completo
full_diagnostic() {
    print_header "DIAGNÓSTICO COMPLETO"
    
    check_config
    echo ""
    check_sessions_table
    echo ""
    check_logs
}

# Comando 6: Aplicar solución rápida
quick_fix() {
    print_header "APLICANDO SOLUCIÓN RÁPIDA"
    
    echo ""
    print_warning "Paso 1: Actualizando .env.production"
    
    if grep -q "SESSION_DOMAIN=\.chelistico\.ar" $PROJECT_PATH/.env.production; then
        sed -i 's/SESSION_DOMAIN=\.chelistico\.ar/SESSION_DOMAIN=api.chelistico.ar/' $PROJECT_PATH/.env.production
        print_success "SESSION_DOMAIN actualizado"
    else
        print_warning "SESSION_DOMAIN ya estaba configurado como: $(grep SESSION_DOMAIN $PROJECT_PATH/.env.production)"
    fi
    
    echo ""
    print_warning "Paso 2: Limpiando sistema"
    clean_all
    
    echo ""
    print_success "✅ Solución aplicada"
    echo ""
    echo "Próximos pasos:"
    echo "1. Abrir navegador incógnito"
    echo "2. Acceder a: https://api.chelistico.ar/admin"
    echo "3. Intentar crear artículo"
    echo "4. Verificar en Network tab que responde 200 OK"
}

# Comando 7: Crear tabla de sesiones si no existe
create_sessions_table() {
    print_header "CREANDO TABLA DE SESIONES"
    
    cd $PROJECT_PATH
    
    php artisan session:table
    print_success "Migración creada"
    
    php artisan migrate
    print_success "Tabla de sesiones creada"
}

# Comando 8: Ver configuración actual
show_config() {
    print_header "CONFIGURACIÓN ACTUAL"
    
    cd $PROJECT_PATH
    
    php artisan config:show session || {
        echo "Alternativa (lectura de archivo):"
        grep -E "SESSION_|SANCTUM_|CORS_" $PROJECT_PATH/.env.production
    }
}

# Main
case "${1:-help}" in
    config)
        check_config
        ;;
    sessions)
        check_sessions_table
        ;;
    logs)
        check_logs
        ;;
    clean)
        clean_all
        ;;
    diagnose)
        full_diagnostic
        ;;
    fix)
        quick_fix
        ;;
    migrate)
        create_sessions_table
        ;;
    show-config)
        show_config
        ;;
    *)
        cat << HELP
${BLUE}╔════════════════════════════════════════════════════════════╗${NC}
${BLUE}║ 🔧 Debug CSRF - HTTP 403 en Livewire                      ║${NC}
${BLUE}║════════════════════════════════════════════════════════════║${NC}
${BLUE}║ Uso: bash $0 [comando]                    ║${NC}
${BLUE}╚════════════════════════════════════════════════════════════╝${NC}

${YELLOW}Comandos disponibles:${NC}

  ${GREEN}config${NC}          Ver configuración de sesiones (.env)
  ${GREEN}sessions${NC}        Verificar tabla de sesiones en BD
  ${GREEN}logs${NC}            Buscar errores CSRF/403 en logs
  ${GREEN}clean${NC}           Limpiar sesiones, caches y reiniciar servicios
  ${GREEN}diagnose${NC}        Diagnóstico completo (config + BD + logs)
  ${GREEN}fix${NC}             APLICAR SOLUCIÓN RÁPIDA (actualizar config + clean)
  ${GREEN}migrate${NC}         Crear tabla de sesiones (si no existe)
  ${GREEN}show-config${NC}     Ver configuración detallada
  
${YELLOW}Ejemplos:${NC}

  # Ver configuración actual
  bash $0 config

  # Diagnóstico completo (empezar por aquí)
  bash $0 diagnose

  # Aplicar solución (ejecutar después de diagnóstico)
  bash $0 fix

  # Si falla, crear tabla de sesiones
  bash $0 migrate

${YELLOW}Notas:${NC}

  - Requiere acceso SSH al servidor
  - Algunos comandos requieren sudo
  - Hacer backup antes de ejecutar 'fix'

HELP
        ;;
esac
