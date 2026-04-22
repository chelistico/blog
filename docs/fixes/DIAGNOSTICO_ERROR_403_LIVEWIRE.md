# 🔴 Diagnóstico: Error HTTP 403 en Livewire (Producción)

**Fecha:** 21 de Abril de 2026  
**Endpoint:** `POST /livewire/update`  
**Host:** `api.chelistico.ar`  
**Status:** 403 Forbidden  
**Acción:** Crear primer artículo en Filament Admin

---

## 📊 Análisis de Causas Raíz

### **Causa Principal Identificada: ✅ CSRF Token Inválido / Token Mismatch**

El error 403 en Livewire generalmente indica un **problema de CSRF (Cross-Site Request Forgery)** o **desalineación de configuración de sesión**.

**Evidencias del Proyecto:**

```env
# .env.production
SESSION_DRIVER=database          # ✅ Correcto para producción
SESSION_DOMAIN=.chelistico.ar    # ⚠️ PROBLEMA: Dominio con punto al inicio
SESSION_SECURE_COOKIE=true       # ✅ Correcto (HTTPS)
SESSION_SAME_SITE=lax            # ✅ Correcto
SESSION_HTTP_ONLY=true           # ✅ Correcto

SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar
```

**Middleware en Filament (línea 71 de AdminPanelProvider.php):**
```php
PreventRequestForgery::class  // ✅ Habilitado - Requiere CSRF Token
```

---

## 🔍 Causas Probables (En Orden de Probabilidad)

### 1. **🔴 Problema de Session Domain (CRÍTICO)**

**Síntoma:**
- SESSION_DOMAIN=`.chelistico.ar` (con punto al inicio)
- Requests desde `api.chelistico.ar` pueden no coincidir con la cookie de sesión

**Por qué ocurre:**
- La cookie de sesión se crea con dominio `.chelistico.ar` (wildcard)
- Pero el servidor está en `api.chelistico.ar` (subdominio específico)
- Las sesiones no se sincronizan correctamente entre subrdomios
- Livewire no puede recuperar el CSRF token del servidor

**Impacto:**
```
Flujo de Error:
1. Usuario abre admin panel en api.chelistico.ar
2. Navegador recibe cookie de sesión (dominio: .chelistico.ar)
3. Usuario completa formulario de artículo
4. Frontend genera Livewire request con CSRF token
5. Servidor no puede verificar el token (session corrupted)
6. Middleware PreventRequestForgery rechaza con 403
```

**Verificación:**
```bash
# En navegador (DevTools):
# - Application > Cookies > chelistico.ar
# Buscar cookie "techdaily-session" o similar
# Dominio debe ser: .chelistico.ar
# Secure: sí, HttpOnly: sí
```

---

### 2. **🟠 Problema de SameSite Cookie (PROBABLE)**

**Síntoma:**
- `SESSION_SAME_SITE=lax`
- En producción con HTTPS/3, algunas navegadores son más restrictivas

**Por qué ocurre:**
- SameSite=lax puede rechazar cookies en cross-site requests
- Si el frontend y backend no comparten exactamente el mismo dominio
- Livewire no envía el cookie con la solicitud

**Verificación:**
```bash
# Network tab en DevTools:
# POST /livewire/update
# Headers > Cookie: ¿Hay sesión cookie?
```

---

### 3. **🟠 Problema de SANCTUM_STATEFUL_DOMAINS**

**Síntoma:**
- Configuración incompleta o incorrecta

**Línea en `.env.production`:**
```env
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar
```

**Por qué ocurre:**
- Sanctum controla qué dominios pueden usar session-based auth (Livewire)
- Si falta `www.chelistico.ar` o `www.api.chelistico.ar`, fallaría
- Pero parece estar configurado correctamente

---

### 4. **🟡 Problema de CORS**

**Síntoma:**
- `CORS_ALLOWED_ORIGINS=https://chelistico.ar`

**Por qué ocurre:**
- Si el frontend está en `https://api.chelistico.ar/admin`
- Pero CORS solo permite `https://chelistico.ar`
- Livewire recibe error CORS

**Verificación:**
```bash
# Network tab > Headers > Origin
# POST /livewire/update
# ¿Request Origin: https://api.chelistico.ar?
# ¿Response Access-Control-Allow-Origin: https://chelistico.ar?
```

---

### 5. **🟡 Middleware en Web Routes**

**Archivo:** `routes/web.php` está incompleto

**Problema:**
```php
Route::get('/', function () {
    return view('welcome');
});
```

**Por qué:**
- Filament rutas están en `/admin`
- Pero no vemos donde se registran estas rutas
- Podrían faltar los middleware necesarios

---

### 6. **🔵 Database Sessions Table Missing**

**Síntoma:**
- `SESSION_DRIVER=database`
- Tabla `sessions` en BD podría no existir o estar corrupta

**Por qué ocurre:**
```bash
php artisan session:table  # Migración para tabla de sesiones
php artisan migrate        # No fue ejecutada
```

---

## ✅ PLAN DE SOLUCIÓN (Paso a Paso)

### **Paso 1: Verificar Configuración de Sesión (10 min)**

```bash
# 1. Revisar archivo de configuración actual
cat /home/chelistico/Projects/docker-php84/www/blog/backend/.env.production

# 2. Verificar tabla de sesiones existe
# SSH a servidor:
mysql -u u574610064_chlstc_blog -p u574610064_chlstc_blog \
  -e "SHOW TABLES LIKE 'sessions';"
```

**Solución:**
```env
# Cambiar de:
SESSION_DOMAIN=.chelistico.ar

# A uno de estos (elegir según caso):

# Opción A: Si Filament está en api.chelistico.ar/admin
SESSION_DOMAIN=api.chelistico.ar

# Opción B: Si hay un solo dominio
SESSION_DOMAIN=chelistico.ar

# Opción C: Para cross-subdomain (menos seguro)
SESSION_DOMAIN=.chelistico.ar
SANCTUM_STATEFUL_DOMAINS=api.chelistico.ar,chelistico.ar,*.chelistico.ar
```

---

### **Paso 2: Verificar Sessions Table**

```bash
# Conectarse al servidor en producción:
cd /var/www/html/blog/backend

# Verificar si tabla existe:
php artisan tinker
> DB::table('sessions')->count()
// Si devuelve error, ejecutar migración:

# Ejecutar migración
php artisan migrate

# Limpiar sesiones viejas:
php artisan session:clean
```

---

### **Paso 3: Limpiar CSRF Tokens**

```bash
# Limpiar caches y tokens
php artisan cache:clear
php artisan config:cache
php artisan route:cache
php artisan view:clear

# Forzar regeneración de keys
php artisan key:generate

# Reiniciar sesiones activas
php artisan session:clean
```

---

### **Paso 4: Verificar CORS Configuration**

```bash
# Revisar archivo config/cors.php
cat /home/chelistico/Projects/docker-php84/www/blog/backend/config/cors.php

# Si no existe, crear:
php artisan config:publish cors
```

**Debe incluir:**
```php
'allowed_origins' => [
    'https://api.chelistico.ar',
    'https://chelistico.ar',
    'https://www.chelistico.ar',
],

'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
'supports_credentials' => true,  // ✅ Crítico para Livewire
```

---

### **Paso 5: Verificar Filament Routes (Si usa separación)**

```bash
# Buscar donde se registran rutas de Filament
grep -r "admin\|filament" /home/chelistico/Projects/docker-php84/www/blog/backend/routes/

# Si Filament está en routes/web.php o routes/filament.php:
# Asegurar que tiene todos los middleware necesarios
```

---

### **Paso 6: Verificar HTTPS Redirection**

```bash
# En .env.production:
APP_URL=https://api.chelistico.ar

# En config/app.php, asegurar:
'url' => env('APP_URL', 'https://api.chelistico.ar'),

# En Kernel.php o middleware, buscar:
# \\Illuminate\\Http\\Middleware\\TrustProxies::class
```

---

## 🧪 Checklist de Verificación

Ejecutar en **producción**:

### **A. Verificación de CSRF Token**

```bash
# 1. Abrir navegador en: https://api.chelistico.ar/admin/login
# 2. Inspeccionar HTML:
#    <meta name="csrf-token" content="...">
#    ¿Existe el token? ✅/❌

# 3. Abrir DevTools > Application > Cookies
#    ¿Hay cookie "techdaily-session"? ✅/❌
#    ¿Dominio es correcto? ✅/❌

# 4. Network tab > POST /livewire/update
#    Headers > Cookie: ¿Incluye sesión? ✅/❌
```

### **B. Verificación de Base de Datos**

```bash
# SSH al servidor:
mysql -u u574610064_chlstc_blog -p u574610064_chlstc_blog

# Dentro de MySQL:
SELECT * FROM sessions LIMIT 1;
SELECT COUNT(*) FROM sessions;
```

### **C. Verificación de Logs**

```bash
# Ver últimos errores en producción:
tail -100 /var/www/html/blog/backend/storage/logs/laravel.log | grep -i csrf

# Buscar errores TokenMismatch:
grep "TokenMismatchException\|CSRF\|403" /var/www/html/blog/backend/storage/logs/laravel.log
```

### **D. Verificación de Middleware**

```bash
# Revisar rutas y middleware:
php artisan route:list | grep livewire

# Debe mostrar el middleware aplicado:
# POST /livewire/update .............. -M web,auth
```

---

## 🔧 Soluciones Rápidas (Order de Probabilidad)

### **Solución #1: Ajustar SESSION_DOMAIN** ⭐⭐⭐⭐⭐

**Archivo:** `/home/chelistico/Projects/docker-php84/www/blog/backend/.env.production`

```bash
# Cambiar esta línea:
# SESSION_DOMAIN=.chelistico.ar

# Por:
SESSION_DOMAIN=api.chelistico.ar
```

**Luego:**
```bash
# Limpiar sesiones y caches
php artisan session:clean
php artisan cache:clear
php artisan config:cache

# Reiniciar servicios si aplica
sudo systemctl restart php-fpm  # o equivalent
```

---

### **Solución #2: Cambiar SameSite a None (Solo si HTTPS)** ⭐⭐⭐

**Archivo:** `.env.production`

```env
# Cambiar de:
SESSION_SAME_SITE=lax

# A:
SESSION_SAME_SITE=none
SESSION_SECURE_COOKIE=true  # Debe estar true si SameSite=none
```

---

### **Solución #3: Crear Tabla de Sesiones** ⭐⭐⭐

```bash
cd /var/www/html/blog/backend

# Crear tabla si no existe:
php artisan session:table
php artisan migrate

# Verificar:
mysql -u u574610064_chlstc_blog -p u574610064_chlstc_blog \
  -e "DESCRIBE sessions;"
```

---

### **Solución #4: Invalidar Sessiones Actuales** ⭐⭐

```bash
# En producción:
php artisan session:clean

# O directamente en BD:
mysql -u u574610064_chlstc_blog -p u574610064_chlstc_blog \
  -e "TRUNCATE sessions;"
```

---

### **Solución #5: Regenerar Key** ⭐

```bash
# ⚠️ Cuidado: Invalida todas las sesiones
php artisan key:generate --force

# Actualizar .env.production:
# APP_KEY=base64:...newkey...

# Limpiar caches:
php artisan cache:clear
php artisan config:cache
```

---

## 📋 Checklist de Resolución

- [ ] **Paso 1:** Verificar SESSION_DOMAIN en .env.production
  - [ ] Cambiar de `.chelistico.ar` a `api.chelistico.ar`
  
- [ ] **Paso 2:** Verificar tabla sessions existe en BD
  - [ ] Ejecutar: `php artisan session:table && php artisan migrate`
  
- [ ] **Paso 3:** Limpiar sesiones y caches
  - [ ] `php artisan session:clean && php artisan cache:clear && php artisan config:cache`
  
- [ ] **Paso 4:** Verificar CORS_ALLOWED_ORIGINS incluye el dominio correcto
  - [ ] Debe incluir: `https://api.chelistico.ar`
  
- [ ] **Paso 5:** Verificar SANCTUM_STATEFUL_DOMAINS
  - [ ] Debe incluir: `api.chelistico.ar`
  
- [ ] **Paso 6:** Limpiar navegador
  - [ ] Cookies de api.chelistico.ar
  - [ ] Cache local
  - [ ] SessionStorage
  
- [ ] **Paso 7:** Probar en incógnito
  - [ ] Nueva ventana privada/incógnito
  - [ ] Intentar crear artículo nuevamente

- [ ] **Paso 8:** Revisar DevTools
  - [ ] Network: POST /livewire/update - Status 200 OK
  - [ ] Console: Sin errores de CSRF
  - [ ] Cookies: Sesión presente

---

## 🎯 Diagnóstico Automático (Script)

```bash
#!/bin/bash
# script: diagnose_csrf.sh

echo "🔍 Diagnosticando problema de CSRF en Livewire..."

cd /var/www/html/blog/backend

echo ""
echo "1. Verificando .env.production:"
grep "SESSION_\|SANCTUM_\|CORS_" .env.production

echo ""
echo "2. Verificando tabla sessions:"
php artisan tinker --execute="echo DB::table('sessions')->count() . ' sesiones activas'"

echo ""
echo "3. Verificando rutas de Filament:"
php artisan route:list | grep livewire

echo ""
echo "4. Revisando logs de errores:"
tail -20 storage/logs/laravel.log | grep -i "csrf\|token\|403"

echo ""
echo "✅ Diagnóstico completado."
```

---

## 🚀 Después de Implementar Solución

**Probar el flujo:**

1. **Limpiar navegador completamente**
   ```
   DevTools > Application > Clear site data
   O: Shift+Ctrl+Del > Clear all
   ```

2. **Acceder al admin panel**
   ```
   https://api.chelistico.ar/admin
   ```

3. **Intentar crear artículo**
   - Completar formulario
   - Hacer clic en "Guardar"
   - ¿Status 200 OK? ✅ **Problema Resuelto**

4. **Si sigue fallando:**
   - Revisar Network > POST /livewire/update > Response
   - Copiar error exacto
   - Revisar logs: `tail -50 storage/logs/laravel.log`

---

## 📞 Escalación

Si después de todas las soluciones sigue fallando:

1. **Recolectar información:**
   - Screenshot de error exacto
   - Contenido de `storage/logs/laravel.log`
   - Output de `php artisan route:list`
   - Output de `php artisan config:show session`

2. **Contactar soporte de Filament:**
   - https://discord.gg/S5DjbzF7
   - Incluir: PHP version, Laravel version, Filament version

3. **Verificar servidor:**
   - ¿SELinux habilitado y bloqueando?
   - ¿Firewall bloqueando POST requests?
   - ¿proxy_pass configurado correctamente en nginx?

---

## 📚 Referencias

- [Laravel CSRF Protection](https://laravel.com/docs/guards)
- [Livewire Security](https://livewire.laravel.com/docs/security)
- [Filament Documentation](https://filamentphp.com)
- [HTTP 403 Forbidden](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403)

---

**Documento Preparado Por:** Dev Fullstack  
**Fecha:** 21 de Abril de 2026  
**Status:** 🔴 CRÍTICO - Requiere atención inmediata
