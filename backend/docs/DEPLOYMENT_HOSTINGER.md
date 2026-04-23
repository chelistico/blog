# Guía de Deployment a Hostinger - Blog Admin Filament

## Resumen Rápido

**¿Necesito compilar algo en local antes de subir?**

✅ **SÍ, necesitas compilar los assets de Filament** antes de hacer push.

---

## ¿Por Qué?

Tu proyecto usa:
- **Vite** para compilar CSS y JS
- **Tailwind CSS** a través de Vite
- **Filament Admin** que necesita CSS compilado

Los archivos en `public/css/` y `public/js/` son **compilados**, no puedes solo hacer pull y esperar que funcione.

---

## Flujo de Deployment Correcto

### Paso 1: Compilar Localmente

```bash
cd ~/Projects/docker-php84/www/blog/backend

# Instalar dependencias (si es la primera vez)
npm install

# Compilar para producción
npm run build
```

**¿Cuándo ejecutar?**
- Después de cambios en `resources/css/app.css`
- Después de cambios en `resources/js/app.js`
- Después de cambios en Tailwind config
- En este caso: **NO hay cambios de frontend**, pero es buena práctica

**Resultado:**
- Se generarán archivos en `public/css/` y `public/js/`
- Estos archivos están versionados en git

### Paso 2: Push a GitHub

```bash
cd ~/Projects/docker-php84/www/blog

# Ver cambios
git status

# Agregar cambios (incluyendo compiled assets)
git add -A

# Commit
git commit -m "Deploy: update production assets"

# Push
git push origin main
```

### Paso 3: Pull en Hostinger (Manual SSH)

```bash
# Conectar por SSH a Hostinger
ssh user@api.chelistico.ar

# Navegar al proyecto
cd /var/www/html/blog/backend

# Pull cambios
git pull origin main

# Limpiar caché de Laravel
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# Opcional: Clear view cache
php artisan view:clear
```

---

## Para tu caso específico (Fix 403)

**Lo que ya hiciste:**
- ✅ Modificaste middleware (`EnsureUserIsAdmin.php`)
- ✅ Modificaste AppServiceProvider
- ✅ Hiciste commit y push

**Lo que falta:**
- ✅ Ya está todo listo (no hay cambios de frontend)
- Solo necesitas hacer el pull en Hostinger

**Comando en Hostinger:**
```bash
cd /var/www/html/blog/backend
git pull origin main
php artisan cache:clear
php artisan config:clear
php artisan route:clear
```

---

## Checklist de Deployment

### Local (Antes de Push)
- [ ] `npm run build` completó sin errores
- [ ] `git status` muestra los cambios esperados
- [ ] `git push` fue exitoso
- [ ] Verificaste en GitHub que los cambios están

### Hostinger (Después de SSH)
- [ ] `git pull` descargó los cambios
- [ ] `php artisan cache:clear` ejecutó sin errores
- [ ] Verificaste en `/var/www/html/blog/backend/app/Http/Middleware/EnsureUserIsAdmin.php` que tiene las nuevas líneas
- [ ] Accediste a `https://api.chelistico.ar/admin` y logueaste sin problemas

---

## Casos Especiales

### ¿Qué pasa si Filament no carga correctamente?

```bash
# En Hostinger:
cd /var/www/html/blog/backend

# Publicar assets de Filament
php artisan filament:install

# Limpiar caché agresivamente
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan optimize:clear

# Si aún hay problemas, reinicia PHP
# (Contacta a Hostinger para hacer restart del PHP-FPM)
```

### ¿Qué si Filament dice que necesita compilación?

Eso significa que `public/js/filament/` está vacío o corrupto:

```bash
# En local:
cd backend
npm install
npm run build
git add -A
git commit -m "Rebuild Filament assets"
git push origin main

# En Hostinger:
git pull origin main
php artisan optimize:clear
```

---

## Arquitectura de tu Proyecto

```
backend/
├── resources/          ← Archivos FUENTE (CSS, JS)
│   ├── css/app.css    (Tailwind + custom)
│   └── js/app.js      (JavaScript custom)
├── public/            ← Archivos COMPILADOS (servidos al navegador)
│   ├── css/filament/  (CSS compilado)
│   └── js/filament/   (JS compilado)
└── vite.config.js     (Configuración de build)
```

**Flujo:**
1. Editas `resources/css/app.css` o `resources/js/app.js`
2. Ejecutas `npm run build` localmente
3. Vite compila los archivos a `public/css/` y `public/js/`
4. Haces push con los archivos compilados
5. En Hostinger solo haces pull (los archivos ya están compilados)

---

## Resumen Final

| Acción | ¿Necesario en Local? | ¿Necesario en Hostinger? |
|--------|----------------------|--------------------------|
| `npm install` | ✅ Sí (si es primera vez) | ❌ No |
| `npm run build` | ✅ Sí (si editaste CSS/JS) | ❌ No |
| `git push` | ✅ Sí | ❌ No |
| `git pull` | ❌ No | ✅ Sí |
| `php artisan cache:clear` | ❌ No (opcional) | ✅ Sí |
| `php artisan filament:install` | ❌ No | ⚠️ Solo si hay problemas |

---

## Para tu Fix 403 Específicamente

```bash
# LOCAL
cd ~/Projects/docker-php84/www/blog/backend
npm run build        # No hay cambios, pero es buena práctica
cd ..
git status           # Deberías ver los cambios que ya hiciste
git push origin main # Ya lo hiciste

# HOSTINGER
cd /var/www/html/blog/backend
git pull origin main
php artisan cache:clear
php artisan config:clear
php artisan route:clear

# TEST
curl https://api.chelistico.ar/admin/login
# Deberías ver el formulario de login sin errores
```

---

**¿Tienes dudas sobre algún paso?** Escribe el comando exacto y te ayudaré.
