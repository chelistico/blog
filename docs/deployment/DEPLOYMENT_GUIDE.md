# Guía de Deploy a Producción - TechDaily Blog

## Pre-Deploy Checklist

### 1. Preparación del Servidor

- [ ] Servidor Linux disponible (Ubuntu 22.04+ o similar recomendado)
- [ ] SSH access configurado
- [ ] Firewall configurado (puertos 22, 80, 443)
- [ ] Domain registrado y DNS apuntando al servidor
- [ ] SSL Certificate generado (Let's Encrypt recomendado)

### 2. Instalación de Dependencias

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Apache/Nginx
sudo apt install -y apache2 apache2-utils

# Instalar PHP 8.4 y extensiones necesarias
sudo apt install -y php8.4 php8.4-cli php8.4-fpm php8.4-mysql php8.4-mbstring \
    php8.4-xml php8.4-curl php8.4-zip php8.4-gd php8.4-intl php8.4-bcmath

# Instalar Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Instalar Node.js (para build del frontend)
curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Instalar MySQL
sudo apt install -y mysql-server
```

### 3. Clonar Repositorio

```bash
# Crear directorio
sudo mkdir -p /var/www/html
sudo chown -R $(whoami):$(whoami) /var/www/html

# Clonar
cd /var/www/html
git clone <repository-url> blog
cd blog
```

### 4. Configuración de Backend

```bash
cd backend

# Instalar dependencias
composer install --optimize-autoloader --no-dev

# Configurar archivo .env
cp .env.example .env
nano .env  # Editar con las credenciales de producción

# Generar key de aplicación
php artisan key:generate

# Crear directorios de storage
mkdir -p storage/app/public/images/articles/embedded
mkdir -p storage/app/public/images/advertisements
```

### 5. Configuración de Permisos (CRÍTICO)

```bash
# Cambiar al directorio del proyecto
cd /var/www/html/blog/backend

# Determinar el usuario web
# Para Apache: www-data (Debian/Ubuntu) o apache (CentOS)
# Para Nginx: El usuario configurado en nginx.conf

# Asignar permisos para storage
chown -R www-data:www-data storage bootstrap/cache
chmod -R 755 storage bootstrap/cache

# Permisos específicos para uploads
chmod 775 storage/app/public/images
chmod 775 storage/app/public/images/articles
chmod 775 storage/app/public/images/articles/embedded
chmod 775 storage/app/public/images/advertisements
chmod 775 storage/app/public/livewire-tmp

# Public directory
chown -R www-data:www-data public
chmod -R 755 public
```

### 6. Configuración de Base de Datos

```bash
# Conectarse a MySQL
mysql -u root -p

# Crear base de datos y usuario
CREATE DATABASE techdaily;
CREATE USER 'techdaily'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON techdaily.* TO 'techdaily'@'localhost';
FLUSH PRIVILEGES;
EXIT;

# Ejecutar migraciones
cd /var/www/html/blog/backend
php artisan migrate --force
php artisan db:seed --class=DatabaseSeeder  # Si hay seeders
```

### 7. Configuración de Apache

```bash
# Habilitar mod_rewrite
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl

# Crear virtual host para API
sudo nano /etc/apache2/sites-available/api-chelistico.conf
```

**Contenido para api-chelistico.conf:**
```apache
<VirtualHost *:80>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
        Options -Indexes +FollowSymLinks
    </Directory>
    
    # Redirigir HTTP a HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]
    
    ErrorLog ${APACHE_LOG_DIR}/api-chelistico-error.log
    CustomLog ${APACHE_LOG_DIR}/api-chelistico-access.log combined
</VirtualHost>

<VirtualHost *:443>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/api.chelistico.ar/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/api.chelistico.ar/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/api.chelistico.ar/chain.pem
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
        Options -Indexes +FollowSymLinks
    </Directory>
    
    <Directory /var/www/html/blog/backend>
        PassEnv APP_ENV APP_DEBUG APP_URL DB_HOST DB_DATABASE
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/api-chelistico-error.log
    CustomLog ${APACHE_LOG_DIR}/api-chelistico-access.log combined
</VirtualHost>
```

```bash
# Habilitar virtual host
sudo a2ensite api-chelistico.conf
sudo a2dissite 000-default.conf

# Verificar sintaxis
sudo apache2ctl configtest

# Reiniciar Apache
sudo systemctl restart apache2
```

### 8. SSL Certificate (Let's Encrypt)

```bash
# Instalar Certbot
sudo apt install -y certbot python3-certbot-apache

# Generar certificado
sudo certbot certonly --standalone -d api.chelistico.ar -d chelistico.ar

# Auto-renovación (se configura automáticamente)
sudo systemctl enable certbot.timer
```

### 9. Configuración de Frontend

```bash
cd /var/www/html/blog/frontend

# Instalar dependencias
npm install

# Build para producción
npm run build

# Los archivos estáticos se generan en 'dist/'
# Servir con un servidor estático (Nginx, Apache, o similar)
```

### 10. Optimizaciones de Laravel

```bash
cd /var/www/html/blog/backend

# Compilar configuración
php artisan config:cache

# Cachear rutas
php artisan route:cache

# Cachear vistas
php artisan view:cache

# Crear symlink de storage
php artisan storage:link
```

### 11. Configuración de Logs

```bash
# Usar systemd journaling en lugar de archivos
# Editar .env:
LOG_CHANNEL=single
# O mejor aún:
LOG_CHANNEL=syslog

# Rotación automática de logs (si usas archivos)
sudo nano /etc/logrotate.d/laravel-blog
```

**Contenido para logrotate:**
```
/var/www/html/blog/backend/storage/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data www-data
    sharedscripts
}
```

### 12. Monitoreo y Mantenimiento

```bash
# Crear script de limpieza y mantenimiento
sudo nano /usr/local/bin/blog-maintenance.sh
```

**Contenido:**
```bash
#!/bin/bash

BLOG_PATH="/var/www/html/blog/backend"

# Limpiar directorios temporales
find $BLOG_PATH/storage/app/public/livewire-tmp -mtime +1 -delete

# Limpiar cache de aplicación
php $BLOG_PATH/artisan cache:clear

# Limpiar cache de configuración
php $BLOG_PATH/artisan config:cache

# Backup de base de datos
DATE=$(date +%Y%m%d_%H%M%S)
mysqldump -u techdaily -p${DB_PASSWORD} techdaily > /backups/techdaily_$DATE.sql

# Comprimir
gzip /backups/techdaily_$DATE.sql

echo "Mantenimiento completado: $DATE"
```

```bash
# Hacer ejecutable
sudo chmod +x /usr/local/bin/blog-maintenance.sh

# Agregar a crontab (ejecutar diariamente a las 2 AM)
sudo crontab -e
# Agregar línea:
# 0 2 * * * /usr/local/bin/blog-maintenance.sh
```

## Post-Deploy Checklist

- [ ] Verificar que la API responde en https://api.chelistico.ar
- [ ] Verificar que la base de datos está conectada
- [ ] Probar upload de imágenes en admin panel
- [ ] Verificar que las imágenes se sirven correctamente
- [ ] Probar endpoints de API con curl o Postman
- [ ] Verificar logs en `storage/logs/laravel.log`
- [ ] Configurar moniteo (Sentry, DataDog, etc)
- [ ] Hacer backup de la base de datos
- [ ] Configurar alertas de disk space

## Troubleshooting Post-Deploy

### Permiso denegado en uploads

```bash
# Verificar permisos
ls -la /var/www/html/blog/backend/storage/app/public/

# Debería mostrar www-data como propietario
# Si no, ejecutar:
chown -R www-data:www-data /var/www/html/blog/backend/storage
chmod -R 775 /var/www/html/blog/backend/storage/app/public/images
```

### Symlink de storage no funciona

```bash
# Recrear symlink
rm /var/www/html/blog/backend/public/storage
cd /var/www/html/blog/backend && php artisan storage:link
```

### Errores 500 en la API

```bash
# Revisar logs
tail -f /var/www/html/blog/backend/storage/logs/laravel.log

# Revisar logs de Apache
tail -f /var/log/apache2/api-chelistico-error.log
```

### Base de datos no conecta

```bash
# Verificar credenciales en .env
# Verificar que MySQL está corriendo
sudo systemctl status mysql

# Probar conexión
mysql -u techdaily -p -h localhost techdaily
```

## Variables de Entorno de Producción

Archivo `.env` recomendado:

```bash
APP_NAME=TechDaily
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.chelistico.ar

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=techdaily
DB_PASSWORD=your_secure_password

MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=465
MAIL_USERNAME=your_email
MAIL_PASSWORD=your_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@chelistico.ar

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

FILAMENT_ADMIN_PATH=admin
FILAMENT_ADMIN_PASSWORD_RESET=true

LOG_CHANNEL=syslog
LOG_LEVEL=warning
```

## Referencias

- [Laravel Deployment Guide](https://laravel.com/docs/deployment)
- [Apache Virtual Hosts](https://httpd.apache.org/docs/2.4/vhosts/)
- [Let's Encrypt](https://letsencrypt.org/)
- [PHP Security Best Practices](https://www.php.net/manual/en/security.php)
