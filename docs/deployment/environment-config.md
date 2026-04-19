# Configuración de Entorno - Desarrollo vs Producción

## Resumen de URLs

| Variable | Desarrollo | Producción |
|----------|------------|------------|
| **Frontend URL** | http://localhost:5173 | https://chelistico.ar |
| **Backend API** | http://blog-api.local/api | https://api.chelistico.ar/api |
| **Frontend API Env** | `VITE_API_BASE_URL=http://blog-api.local/api` | `VITE_API_BASE_URL=https://api.chelistico.ar/api` |

## Configuración MySQL

| Parámetro | Desarrollo | Producción |
|-----------|------------|------------|
| **Host** | `docker_mysql` (contenedor) | Servidor MySQL dedicado |
| **Puerto** | 3306 | 3306 |
| **Database** | techdaily | techdaily |
| **Usuario** | root | tu_usuario |
| **Contraseña** | `toor` | tu_contraseña_segura |

> **Nota**: La contraseña `toor` se encontró inspecting el contenedor Docker con `docker inspect docker_mysql`

## Configuración de Dominio Local

### /etc/hosts (Desarrollo)

```bash
# Backend Laravel API
127.0.0.1  blog-api.local

# Opcional: si el frontend está en otro puerto
# 127.0.0.1  localhost
```

## Frontend - Variables de Entorno

### `.env` (Desarrollo)
```bash
VITE_API_BASE_URL=http://blog-api.local/api
```

### `.env` (Producción)
```bash
VITE_API_BASE_URL=https://api.chelistico.ar/api
```

## Backend - Variables de Entorno

### `.env` (Desarrollo)
```env
APP_ENV=local
APP_DEBUG=true
APP_URL=http://blog-api.local

DB_CONNECTION=mysql
DB_HOST=docker_mysql
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=root
DB_PASSWORD=toor

SANCTUM_STATEFUL_DOMAINS=localhost,localhost:5173,localhost:8000,blog-api.local
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://blog-api.local
```

### `.env` (Producción)
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.chelistico.ar

DB_CONNECTION=mysql
DB_HOST=tu_servidor_mysql
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=tu_usuario
DB_PASSWORD=tu_contraseña_segura

SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar
```

## Configuración de CORS

### Desarrollo
- **Frontend**: http://localhost:5173
- **Backend**: http://blog-api.local

### Producción
- **Frontend**: https://chelistico.ar
- **Backend**: https://api.chelistico.ar

## Cambios al Deployar a Producción

1. **Frontend**:
   - Cambiar `VITE_API_BASE_URL` en `.env`
   - Ejecutar `npm run build`
   - Subir contenido de `dist/` al servidor de hosting

2. **Backend**:
   - Cambiar `.env` con credenciales de producción
   - Ejecutar `php artisan migrate --force`
   - Ejecutar `php artisan db:seed` (primera vez)
   - Limpiar cachés: `php artisan config:cache && php artisan route:cache`

3. **DNS**:
   - Asegurar que `api.chelistico.ar` apunte al servidor
   - Configurar SSL con Let's Encrypt o certificado

## Verificación Post-Deploy

```bash
# Verificar API responde
curl https://api.chelistico.ar/api/home

# Verificar CORS
curl -I -H "Origin: https://chelistico.ar" https://api.chelistico.ar/api/articles

# Verificar SSL
curl -I https://api.chelistico.ar/api/home
```

---

## Comandos Docker Útiles

```bash
# Ver contenedores
docker ps

# Acceder al contenedor PHP
docker exec -it docker_php84 bash

# Ver logs del contenedor MySQL
docker logs docker_mysql

# Reiniciar contenedor PHP
docker restart docker_php84

# Ejecutar comandos Laravel dentro del contenedor
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate

# Ver entorno del contenedor MySQL
docker inspect docker_mysql --format='{{range .Config.Env}}{{println .}}{{end}}' | grep MYSQL
```

### Estructura de Carpetas en Contenedor

```
/var/www/html/blog/
├── backend/                    # Proyecto Laravel
│   ├── app/
│   ├── bootstrap/
│   ├── config/
│   ├── database/
│   ├── public/
│   ├── resources/
│   ├── routes/
│   ├── storage/
│   ├── tests/
│   └── vendor/
└── frontend/                   # (si está montado)
```

### Configuración PHP Temporal

El directorio temporal de PHP está configurado en:
```
/usr/local/etc/php/conf.d/zz-temp.ini
```

Contenido:
```ini
[PHP]
sys_temp_dir = /tmp
upload_tmp_dir = /tmp
```
