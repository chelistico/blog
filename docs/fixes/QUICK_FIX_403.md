# ⚡ QUICK FIX: HTTP 403 en Livewire - Guía Rápida (5 minutos)

**Para:** El usuario que necesita resolver el problema YA  
**Tiempo:** 5 minutos  
**Dificultad:** ⭐⭐ (Fácil)

---

## 🎯 El Problema

```
❌ Error al crear artículo en Filament Admin
❌ Endpoint: POST /livewire/update
❌ Status: 403 Forbidden
```

## ✅ La Solución (En 3 Pasos)

### Paso 1️⃣: Editar .env.production

```bash
# SSH al servidor
ssh usuario@api.chelistico.ar
cd /var/www/html/blog/backend

# Editar el archivo
nano .env.production
```

**Buscar esta línea:**
```env
SESSION_DOMAIN=.chelistico.ar
```

**Cambiarla a:**
```env
SESSION_DOMAIN=api.chelistico.ar
```

**Guardar:** `Ctrl+X` → `Y` → `Enter`

---

### Paso 2️⃣: Limpiar Sesiones

```bash
php artisan session:clean
php artisan cache:clear
php artisan config:cache
```

---

### Paso 3️⃣: Reiniciar Servicios

```bash
sudo systemctl restart php-fpm
```

---

## ✨ ¡Listo! Probar

1. **Limpiar navegador:** `Shift+Ctrl+Del` → Clear all
2. **Acceder:** `https://api.chelistico.ar/admin`
3. **Login** con credenciales
4. **Crear artículo** → ✅ Debería funcionar

---

## 🤔 ¿Todavía no funciona?

Ejecutar este diagnóstico:

```bash
cd /var/www/html/blog/backend

# Verificar tabla de sesiones
php artisan tinker
> DB::table('sessions')->count()
> exit

# Ver logs
tail -20 storage/logs/laravel.log | grep -i "403\|csrf"
```

Si ves `TokenMismatchException`, el problema es CSRF token.  
Si ves errores de BD, ejecutar:

```bash
php artisan session:table
php artisan migrate
```

---

## 📋 Checklist Post-Fix

- [ ] `.env.production` actualizado
- [ ] `php artisan session:clean` ejecutado
- [ ] `php artisan cache:clear` ejecutado
- [ ] `php artisan config:cache` ejecutado
- [ ] `sudo systemctl restart php-fpm` ejecutado
- [ ] Navegador limpiado
- [ ] Admin panel accesible
- [ ] Crear artículo funciona (200 OK)

---

## 🆘 Contacto Rápido

| Problema | Acción |
|----------|--------|
| Tabla `sessions` no existe | `php artisan session:table && php artisan migrate` |
| PHP-FPM no reinicia | `sudo systemctl status php-fpm` para ver error |
| Cookie todavía no funciona | Cambiar `SESSION_SAME_SITE=none` en .env.production |
| Nginx devuelve 403 | Contactar DevOps - Revisar nginx config |

---

**¡Eso es todo!**

Documento ultracorto preparado para resolver en 5 minutos.

---

## 📚 Si necesitas entender más

Lee: `DIAGNOSTICO_ERROR_403_LIVEWIRE.md` (análisis completo)
Lee: `SOLUCION_IMPLEMENTAR_FIX_403.md` (paso a paso detallado)
