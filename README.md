# TechDaily - Blog de Tecnología

Proyecto de blog de tecnología construido con React (frontend) y Laravel 12 (backend API).

## Estructura del Proyecto

```
blog/
├── frontend/          # Aplicación React + TypeScript + Vite
├── backend/           # API Laravel 12
└── .opencode/        # Documentación y workitems para agentes IA
```

## Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                         PRODUCCIÓN                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────────────┐         ┌─────────────────────────┐   │
│   │   Frontend          │         │   Backend API           │   │
│   │   chelistico.ar     │ ──────▶ │   api.chelistico.ar    │   │
│   │   (Static files)    │  REST   │   /api/*                │   │
│   └─────────────────────┘         └─────────────────────────┘   │
│                                                                  │
│   ┌─────────────────────┐                                      │
│   │   MySQL / Database  │                                      │
│   │   (Server)          │                                      │
│   └─────────────────────┘                                      │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    DESARROLLO LOCAL                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   Contenedor: docker_php84 (Apache + PHP 8.4)             │   │
│   │                                                          │   │
│   │   Frontend: localhost:5173 (Vite dev server)             │   │
│   │   Backend: blog-api.local (Virtual Host)                  │   │
│   │                                                          │   │
│   │   Rutas: /var/www/html/blog/backend/public               │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│   ┌─────────────────────────────────────────────────────────┐   │
│   │   Contenedor: docker_mysql (MySQL 8.x)                   │   │
│   │                                                          │   │
│   │   Host: docker_mysql:3306                               │   │
│   │   Usuario: root / Contraseña: toor                       │   │
│   │   Base de datos: techdaily                              │   │
│   └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│   Archivos hosts (etc/hosts):                                   │
│   127.0.0.1  blog-api.local                                     │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## URLs del Proyecto

### Desarrollo Local

| Servicio | URL | Puerto |
|----------|-----|--------|
| Frontend (Vite) | http://localhost:5173 | 5173 |
| Backend API | http://blog-api.local | 80 |
| phpMyAdmin | http://localhost:8080 | 8080 |

### Producción

| Servicio | URL |
|----------|-----|
| Frontend | https://chelistico.ar |
| Backend API | https://api.chelistico.ar |

## Configuración de Virtual Hosts

### Desarrollo (blog-api.local)

```apache
# /etc/apache2/sites-available/blog-api.conf
<VirtualHost *:80>
    ServerName blog-api.local
    DocumentRoot /var/www/html/blog/backend/public
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
        Options -Indexes +FollowSymLinks
    </Directory>
    
    <Directory /var/www/html/blog/backend>
        PassEnv APP_ENV APP_DEBUG APP_URL
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/blog-api-error.log
    CustomLog ${APACHE_LOG_DIR}/blog-api-access.log combined
</VirtualHost>
```

### Producción (api.chelistico.ar)

```apache
# /etc/apache2/sites-available/chelistico-api.conf
<VirtualHost *:80>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
    </Directory>
    
    # HTTPS redirect
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]
</VirtualHost>

<VirtualHost *:443>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    SSLEngine on
    SSLCertificateFile /path/to/cert.pem
    SSLCertificateKeyFile /path/to/key.pem
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
    </Directory>
    
    # Configuración Laravel
    <Directory /var/www/html/blog/backend>
        PassEnv APP_ENV APP_DEBUG APP_URL DB_HOST DB_DATABASE
    </Directory>
</VirtualHost>
```

## Configuración de Hosts Local

Agregar en `/etc/hosts`:

```bash
# Desarrollo - Backend Laravel
127.0.0.1  blog-api.local
```

## Comandos Docker

```bash
# Ver contenedores activos
docker ps

# Acceder a PHP
docker exec -it docker_php84 bash

# Acceder a MySQL
docker exec -it docker_mysql mysql -uroot -ptoor

# Ver logs
docker logs -f docker_php84
docker logs -f docker_mysql

# Reiniciar PHP
docker restart docker_php84
```

## Variables de Entorno

### Frontend (.env)

```bash
# Desarrollo
VITE_API_BASE_URL=http://blog-api.local/api

# Producción
VITE_API_BASE_URL=https://api.chelistico.ar/api
```

### Backend (.env)

```bash
# Desarrollo
DB_CONNECTION=mysql
DB_HOST=docker_mysql
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=root
DB_PASSWORD=toor

# Producción
DB_CONNECTION=mysql
DB_HOST=your_production_host
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=your_user
DB_PASSWORD=your_secure_password
```

## Comandos de Desarrollo

```bash
# Frontend (desde el host)
cd frontend
npm install
npm run dev
# Accesible en http://localhost:5173

# Backend (usando comandos Docker)
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate
docker exec -w /var/www/html/blog/backend docker_php84 php artisan db:seed
# Accesible en http://blog-api.local
```

## Comandos de Producción

```bash
# Build Frontend
cd frontend
npm run build

# Deployment Backend
# En el servidor de producción
composer install --optimize
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## Configuración de Permisos y Storage (IMPORTANTE PARA PRODUCCIÓN)

### Estructura de Directorios Storage

El sistema de upload de imágenes requiere una estructura específica de directorios con permisos correctos:

```
storage/app/public/
├── images/
│   ├── articles/              # Imágenes principales de artículos
│   │   └── embedded/          # Imágenes embebidas en artículos
│   └── advertisements/        # Imágenes de publicidades
└── livewire-tmp/             # Temporal (generado automáticamente por Livewire)
```

### Configuración de Permisos (CRÍTICO)

#### En Desarrollo (Docker)

```bash
# Dentro del contenedor o en el host
cd /var/www/html/blog/backend

# Crear directorios si no existen
mkdir -p storage/app/public/images/articles/embedded
mkdir -p storage/app/public/images/advertisements

# Asignar permisos correctos (el usuario web debe poder escribir)
# En Docker, www-data es el usuario del servidor web
chown -R www-data:www-data storage/app/public/images
chmod -R 775 storage/app/public/images

# El directorio storage completo debe ser escribible
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache
```

#### En Producción (Servidor Linux)

```bash
# Determinar el usuario del servidor web
# Apache: www-data (Debian/Ubuntu) o apache (CentOS/RHEL)
# Nginx + PHP-FPM: www-data o el usuario configurado en php-fpm.conf

# Para Apache en Debian/Ubuntu
chown -R www-data:www-data /var/www/html/blog/backend/storage
chmod -R 755 /var/www/html/blog/backend/storage
chmod -R 755 /var/www/html/blog/backend/bootstrap/cache

# Directorios específicos de uploads necesitan permisos de escritura
chmod 775 /var/www/html/blog/backend/storage/app/public/images
chmod 775 /var/www/html/blog/backend/storage/app/public/images/articles
chmod 775 /var/www/html/blog/backend/storage/app/public/images/articles/embedded
chmod 775 /var/www/html/blog/backend/storage/app/public/images/advertisements

# Para Nginx + PHP-FPM, reemplazar www-data por el usuario de php-fpm
# chown -R www-data:www-data /var/www/html/blog/backend/storage
```

#### Verificar Permisos

```bash
# Listar permisos actuales
ls -la /var/www/html/blog/backend/storage/app/public/

# La salida debe mostrar algo como:
# drwxrwxr-x  4 www-data www-data  4096 Apr 16 10:08 images
# dr-xr-xr-x  2 www-data www-data  4096 Apr 16 10:18 livewire-tmp

# Si ves 'root' en lugar de 'www-data', los permisos están mal
```

### Symlink de Storage

Filament/Laravel requiere un symlink para servir archivos públicos:

```bash
# Crear el symlink (lo hace automáticamente, pero puede necesitar recrearlo)
php artisan storage:link

# Verificar que el symlink existe
ls -la public/storage

# Salida esperada:
# lrwxrwxr-x  1 www-data www-data  30 Apr 16 10:00 storage -> ../storage/app/public
```

### Troubleshooting de Permisos

#### Problema: "Permission denied" al subir archivos

```bash
# Causa: El directorio images/ es propiedad de root, no del usuario web

# Solución:
# 1. Verificar el usuario/grupo actual
ls -la storage/app/public/images

# 2. Si muestra 'root', cambiar a www-data
chown -R www-data:www-data storage/app/public/images

# 3. Asegurar permisos de escritura
chmod -R 775 storage/app/public/images
```

#### Problema: Las imágenes suben pero no aparecen después

```bash
# Causa: El directorio livewire-tmp no tiene permisos de escritura
# Solución:
chmod -R 775 storage/app/public/livewire-tmp

# O mejor aún, recrear todo el storage con permisos correctos:
chown -R www-data:www-data storage
chmod -R 775 storage
```

#### Problema: El symlink public/storage no existe

```bash
# Verificar si existe
test -L public/storage && echo "Symlink existe" || echo "Symlink NO existe"

# Recrearlo
php artisan storage:link

# Si dice "El archivo existe", eliminarlo primero
rm public/storage
php artisan storage:link
```

### Configuración Recomendada para Producción

```bash
#!/bin/bash
# Script de configuración de permisos para producción

LARAVEL_PATH="/var/www/html/blog/backend"
WEB_USER="www-data"  # Cambiar según el servidor (apache, www-data, etc)
WEB_GROUP="www-data"

# Crear directorios necesarios
mkdir -p $LARAVEL_PATH/storage/app/public/images/articles/embedded
mkdir -p $LARAVEL_PATH/storage/app/public/images/advertisements

# Asignar propietario
chown -R $WEB_USER:$WEB_GROUP $LARAVEL_PATH/storage
chown -R $WEB_USER:$WEB_GROUP $LARAVEL_PATH/bootstrap/cache

# Permisos base
chmod -R 755 $LARAVEL_PATH/storage
chmod -R 755 $LARAVEL_PATH/bootstrap/cache

# Permisos de escritura para directorios específicos
chmod 775 $LARAVEL_PATH/storage/app/public/images
chmod 775 $LARAVEL_PATH/storage/app/public/images/articles
chmod 775 $LARAVEL_PATH/storage/app/public/images/articles/embedded
chmod 775 $LARAVEL_PATH/storage/app/public/images/advertisements
chmod 775 $LARAVEL_PATH/storage/app/public/livewire-tmp

# Crear/Verificar symlink
rm -f $LARAVEL_PATH/public/storage
cd $LARAVEL_PATH && php artisan storage:link

echo "✓ Permisos configurados correctamente"
```

### Considerar al Hacer Deploy

1. **Antes de ejecutar migración de datos**: Asegurar que los permisos estén correctos
2. **En CI/CD pipelines**: Incluir paso de configuración de permisos después del deploy
3. **Archivos subidos**: Considerar usar servicios cloud (S3, CloudFront, etc) para producción
4. **Limpieza de temporal**: Limpiar `livewire-tmp` regularmente con un cron job:
   ```bash
   # Limpiar archivos de más de 24 horas
   find /var/www/html/blog/backend/storage/app/public/livewire-tmp -mtime +1 -delete
   ```

### Migración a Producción - Checklist

- [ ] Directorios de storage creados
- [ ] Permisos de storage configurados para el usuario web
- [ ] Symlink de storage creado
- [ ] `.env` configurado para producción
- [ ] Base de datos migrada: `php artisan migrate --force`
- [ ] Cache de configuración: `php artisan config:cache`
- [ ] Routes caché: `php artisan route:cache`
- [ ] Views caché: `php artisan view:cache`
- [ ] Almacenamiento caché: `php artisan storage:link`
- [ ] Logs y temp limpios
- [ ] Verificar uploads en admin panel

## Documentación
 Detallada

- [Frontend README](./frontend/README.md)
- [Backend README](./backend/README.md)
- [Workitems](./.opencode/workitems/00-plan-overview.md)

## Base de Datos

### Desarrollo
- **Contenedor**: `docker_mysql`
- **Host en Laravel**: `docker_mysql` (para conectar desde docker_php84)
- **Host local**: `localhost:3306` (para herramientas externas)
- **Usuario**: `root`
- **Contraseña**: `toor`

### Producción
- MySQL Server dedicado o servicio cloud (AWS RDS, DigitalOcean, etc.)

## Documentación

- [Frontend README](./frontend/README.md)
- [Backend README](./backend/README.md)
- [Workitems](./.opencode/workitems/00-plan-overview.md)
- [Guía Docker](./.opencode/docs/docker-guide.md)
- [Configuración Virtual Hosts](./.opencode/docs/virtual-hosts.md)
- [Configuración de Entorno](./.opencode/docs/environment-config.md)
