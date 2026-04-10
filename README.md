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

## Documentación Detallada

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
