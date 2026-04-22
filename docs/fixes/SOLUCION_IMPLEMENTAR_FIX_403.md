# 🔧 SOLUCIÓN: Implementar Fix para HTTP 403 en Livewire

**Estado:** Plan de acción detallado para resolver el error 403  
**Tiempo Estimado:** 15-30 minutos  
**Riesgo:** Bajo (cambios de configuración no-destructivos)

---

## 🎯 Resumen Ejecutivo

El error 403 en `/livewire/update` está causado por **problemas de configuración de CSRF y sesiones en producción**. La solución principal es alinear la configuración de dominio de sesión con el servidor actual.

**Solución Recomendada:** Implementar cambios en `.env.production` + limpiar sesiones

---

## 📋 Paso 1: Diagnosticar el Problema Actual

Primero, determinar si es realmente un problema de CSRF o sesión:

### 1.1 Revisar logs recientes

```bash
# SSH al servidor de producción
ssh usuario@api.chelistico.ar

# Navegar al proyecto
cd /var/www/html/blog/backend

# Ver últimos 50 logs
tail -50 storage/logs/laravel.log
```

**Buscar en los logs:**
- `TokenMismatchException` - CSRF token inválido
- `MethodNotAllowedException` - Método HTTP incorrecto
- `HttpException 403` - Acceso denegado

### 1.2 Verificar tabla de sesiones

```bash
# Conectarse a MySQL
mysql -u u574610064_chlstc_blog -p

# Dentro de MySQL:
USE u574610064_chlstc_blog;
SHOW TABLES LIKE 'sessions';
SELECT COUNT(*) FROM sessions;
```

**Resultado esperado:**
- Tabla `sessions` debe existir ✅
- Debe tener registros de sesiones activas

**Si no existe la tabla:**
```bash
# Ejecutar migración desde servidor
php artisan session:table
php artisan migrate
```

### 1.3 Verificar configuración de navegador

**En el navegador:**
1. Abrir Developer Tools (F12)
2. Ir a **Application > Cookies**
3. Buscar cookies del dominio `api.chelistico.ar`
4. Verificar:
   - ¿Existe cookie `techdaily-session`? (o similar)
   - ¿Domain es `.chelistico.ar` o `api.chelistico.ar`?
   - ¿Flags: Secure=✅, HttpOnly=✅, SameSite=Lax?

---

## 🔨 Paso 2: Implementar Solución (3 cambios)

### 2.1 Actualizar .env.production

**Archivo:** `/var/www/html/blog/backend/.env.production`

```bash
# Conectarse al servidor
ssh usuario@api.chelistico.ar
cd /var/www/html/blog/backend

# Editar archivo (usar nano, vim, etc.)
nano .env.production
```

**Cambios a realizar:**

```env
# ANTES:
SESSION_DOMAIN=.chelistico.ar

# DESPUÉS:
SESSION_DOMAIN=api.chelistico.ar
```

**Explicación:**
- `.chelistico.ar` (con punto inicial) = wildcard para cualquier subdominio
- `api.chelistico.ar` (sin punto inicial) = específico solo para ese subdominio
- Si Filament está en `api.chelistico.ar/admin`, usar `api.chelistico.ar`

**Cambio Adicional (Opcional pero Recomendado):**

```env
# ANTES:
CORS_ALLOWED_ORIGINS=https://chelistico.ar

# DESPUÉS:
CORS_ALLOWED_ORIGINS=https://chelistico.ar,https://api.chelistico.ar

# ANTES:
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar

# DESPUÉS:
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar,www.chelistico.ar
```

**Guardar archivo:**
- Si usas nano: `Ctrl+X` > `Y` > `Enter`
- Si usas vim: `:wq` > `Enter`

---

### 2.2 Limpiar Sesiones y Caches

```bash
# Estar en /var/www/html/blog/backend

# 1. Limpiar todas las sesiones activas
php artisan session:clean

# 2. Limpiar cache de aplicación
php artisan cache:clear

# 3. Recompilar configuración
php artisan config:cache

# 4. Limpiar view cache
php artisan view:clear

# 5. (Opcional) Regenerar autoload
composer dump-autoload
```

**Output esperado:**
```
Application cache cleared!
Configuration cache cleared!
Compiled views cleared!
```

---

### 2.3 Reiniciar Servicios

```bash
# Reiniciar PHP-FPM (o equivalent)
sudo systemctl restart php-fpm

# Reiniciar Nginx (si es aplicable)
sudo systemctl restart nginx

# Verificar que servicios estén activos
sudo systemctl status php-fpm
sudo systemctl status nginx
```

**Output esperado:**
```
● php-fpm.service - The PHP FastCGI Process Manager
   Loaded: loaded (/etc/systemd/system/php-fpm.service; enabled; vendor preset: enabled)
   Active: active (running)
```

---

## 🧪 Paso 3: Validar la Solución

### 3.1 Test desde navegador

**Pasos:**

1. **Limpiar navegador completamente**
   - DevTools > Application > Clear site data
   - O: Keyboard: `Shift + Ctrl + Del`
   - Seleccionar: Cookies, Cache, SessionStorage
   - Click: Clear data

2. **Acceder al admin panel**
   ```
   https://api.chelistico.ar/admin
   ```

3. **Login con credenciales**
   - Usuario: (admin user)
   - Contraseña: (password)

4. **Navegar a Create Article**
   ```
   Artículos > Create new
   ```

5. **Completar formulario**
   - Title: "Test Article"
   - Content: "Test content for CSRF validation"
   - (Otros campos requeridos)

6. **Hacer Submit**
   - Click en "Save" o "Create"
   - Esperar respuesta

7. **Verificar resultado**
   - ¿Devuelve 200 OK? ✅ **ÉXITO**
   - ¿Aparece nuevo artículo? ✅ **ÉXITO**
   - ¿Devuelve 403? ❌ Continuar con próximos pasos

### 3.2 Debug con DevTools

**Si sigue fallando, investigar:**

1. **Network tab**
   - Click en POST `/livewire/update`
   - Ver pestaña "Response"
   - ¿Qué dice exactamente el error?

2. **Headers tab**
   - ¿Cookie contiene sesión?
   - ¿Header X-CSRF-Token presente?
   - ¿Header X-Requested-With: XMLHttpRequest?

3. **Console tab**
   - ¿Errores JavaScript?
   - ¿Warnings sobre CORS?

### 3.3 Verificar en Logs

```bash
# Ver últimos errores
tail -30 /var/www/html/blog/backend/storage/logs/laravel.log

# Buscar específicamente 403
grep "403\|TokenMismatch\|Forbidden" /var/www/html/blog/backend/storage/logs/laravel.log | tail -10
```

---

## 🔄 Paso 4: Si Sigue Fallando

### Solución Alternativa #1: Cambiar SameSite

```bash
# Editar .env.production
nano .env.production

# Cambiar:
SESSION_SAME_SITE=none
SESSION_SECURE_COOKIE=true  # Muy importante
```

**Guardar y ejecutar:**
```bash
php artisan config:cache
php artisan session:clean
sudo systemctl restart php-fpm
```

---

### Solución Alternativa #2: Verificar Kernel Middleware

```bash
# Verificar que existe app/Http/Kernel.php
find . -name "Kernel.php" -type f

# Si existe, revisar si tiene PreventRequestForgery
grep "PreventRequestForgery" app/Http/Kernel.php
```

**Si el archivo no existe o no tiene el middleware:**

Crear/actualizar `app/Http/Kernel.php`:

```php
<?php

namespace App\Http;

use Illuminate\Foundation\Http\Kernel as HttpKernel;

class Kernel extends HttpKernel
{
    protected $middleware = [
        // ... otros middleware
    ];

    protected $middlewareGroups = [
        'web' => [
            \App\Http\Middleware\EncryptCookies::class,
            \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse::class,
            \Illuminate\Session\Middleware\StartSession::class,
            \Illuminate\View\Middleware\ShareErrorsFromSession::class,
            \Illuminate\Foundation\Http\Middleware\PreventRequestForgery::class, // ✅
            \Illuminate\Routing\Middleware\SubstituteBindings::class,
        ],

        'api' => [
            // API routes typically don't need CSRF
        ],
    ];
}
```

---

### Solución Alternativa #3: Forzar Regeneración de Key

⚠️ **ADVERTENCIA:** Esto invalida todas las sesiones activas

```bash
# ¡Solo si las otras soluciones no funcionan!
php artisan key:generate --force

# Limpiar caches
php artisan cache:clear
php artisan config:cache
php artisan session:clean

# Reiniciar
sudo systemctl restart php-fpm
```

**Después:** Todos los usuarios deben hacer login nuevamente

---

## ✅ Checklist de Implementación

- [ ] **Diagnóstico Completado**
  - [ ] Revisé logs en `/var/www/html/blog/backend/storage/logs/laravel.log`
  - [ ] Verifiqué tabla `sessions` existe en BD
  - [ ] Revisé cookies en navegador

- [ ] **Cambios de Configuración**
  - [ ] Edité `.env.production`: `SESSION_DOMAIN=api.chelistico.ar`
  - [ ] Actualicé `CORS_ALLOWED_ORIGINS` si fue necesario
  - [ ] Actualicé `SANCTUM_STATEFUL_DOMAINS` si fue necesario

- [ ] **Limpieza de Sistema**
  - [ ] Ejecuté `php artisan session:clean`
  - [ ] Ejecuté `php artisan cache:clear`
  - [ ] Ejecuté `php artisan config:cache`
  - [ ] Ejecuté `php artisan view:clear`

- [ ] **Reinicio de Servicios**
  - [ ] Reinicié PHP-FPM (`sudo systemctl restart php-fpm`)
  - [ ] Reinicié Nginx (si aplica)
  - [ ] Verifiqué que servicios están running

- [ ] **Validación**
  - [ ] Limpié navegador completamente
  - [ ] Hice login en admin panel
  - [ ] Intenté crear artículo
  - [ ] Verifiqué en DevTools > Network (200 OK)
  - [ ] Verifiqué en logs - sin errores 403

- [ ] **Documentación**
  - [ ] Documenté cambios realizados
  - [ ] Guardé copias de backup de .env
  - [ ] Notifiqué al equipo de cambios

---

## 📊 Comparación: Antes vs Después

### Antes (Problema)

```env
SESSION_DOMAIN=.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar
```

**Resultado:** Cookie de sesión con dominio wildcard `.chelistico.ar` no sincroniza bien con solicitudes a `api.chelistico.ar` específicamente → 403 Forbidden

### Después (Solución)

```env
SESSION_DOMAIN=api.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar,https://api.chelistico.ar
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar,www.chelistico.ar
```

**Resultado:** Cookie de sesión específica para `api.chelistico.ar` sincroniza correctamente con solicitudes Livewire → 200 OK

---

## 🎓 Explicación Técnica

### Por qué ocurría el error

```
┌─────────────────────────────────────────────────────┐
│ 1. Usuario accede a api.chelistico.ar/admin         │
│    Servidor asigna: session=abc123 (dominio: .*)    │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│ 2. Usuario completa formulario de artículo          │
│    Frontend prepara Livewire request                │
│    Incluye: X-CSRF-Token, Cookie: session=abc123   │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│ 3. POST /livewire/update enviado al servidor       │
│    Servidor recibe pero:                           │
│    - Session cookie dominio: .chelistico.ar        │
│    - Request origin: api.chelistico.ar             │
│    - NO COINCIDEN EXACTAMENTE ❌                    │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│ 4. Middleware PreventRequestForgery rechaza         │
│    Razón: No puede verificar CSRF token            │
│    porque no encuentra la sesión                   │
│    Respuesta: HTTP 403 Forbidden                   │
└─────────────────────────────────────────────────────┘
```

### Por qué la solución funciona

```
┌─────────────────────────────────────────────────────┐
│ 1. Usuario accede a api.chelistico.ar/admin         │
│    Servidor asigna: session=abc123                  │
│    (dominio: api.chelistico.ar específico)          │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│ 2. Usuario completa formulario de artículo          │
│    Frontend prepara Livewire request                │
│    Incluye: X-CSRF-Token, Cookie: session=abc123   │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│ 3. POST /livewire/update enviado al servidor       │
│    Servidor recibe:                                │
│    - Session cookie dominio: api.chelistico.ar    │
│    - Request origin: api.chelistico.ar             │
│    - ✅ COINCIDEN PERFECTAMENTE                     │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│ 4. Middleware PreventRequestForgery verifica        │
│    Razón: Encuentra la sesión correctamente        │
│    y verifica el CSRF token exitosamente           │
│    Respuesta: HTTP 200 OK ✅                        │
└─────────────────────────────────────────────────────┘
```

---

## 🚨 Troubleshooting Adicional

| Síntoma | Causa | Solución |
|---------|-------|----------|
| 403 después de cambios | Cache no actualizado | `php artisan cache:clear` |
| Cookie no se establece | Domain mismatch | Verificar `SESSION_DOMAIN` |
| CORS error en console | Dominio no en whitelist | Agregar a `CORS_ALLOWED_ORIGINS` |
| Sesión se pierde | SameSite muy restrictivo | Cambiar `SESSION_SAME_SITE=none` |
| "Invalid CSRF token" | Token expirado | Limpiar navegador + refresh |
| BD error en sessions | Tabla corrupta | `php artisan session:table` + migrate |

---

## 📝 Comandos Rápidos

**Copiar y pegar en servidor:**

```bash
# Todo en uno
cd /var/www/html/blog/backend && \
php artisan session:clean && \
php artisan cache:clear && \
php artisan config:cache && \
php artisan view:clear && \
sudo systemctl restart php-fpm && \
echo "✅ Sistema reiniciado correctamente"
```

---

## 📞 Soporte

Si después de seguir estos pasos sigue fallando:

1. **Recolectar información:**
   ```bash
   php artisan config:show session > config_session.txt
   php artisan route:list | grep livewire > routes_livewire.txt
   tail -50 storage/logs/laravel.log > logs_recent.txt
   ```

2. **Contactar con:**
   - DevOps/Sistema - Verificar nginx config
   - Backend Dev - Revisar Filament setup
   - Filament Community - https://discord.gg/S5DjbzF7

---

**Documento Preparado Por:** Dev Fullstack  
**Última Actualización:** 21 de Abril de 2026  
**Status:** 🟢 LISTO PARA IMPLEMENTAR
