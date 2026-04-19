# Configuración de Virtual Hosts

## Desarrollo Local

### Frontend (no requiere vhost, usa Vite)
```bash
# En la carpeta frontend/
npm run dev
# Accesible en http://localhost:5173
```

### Backend API (blog-api.local)

#### 1. Crear archivo de configuración Apache

```bash
# /etc/apache2/sites-available/blog-api.conf
<VirtualHost *:80>
    ServerName blog-api.local
    DocumentRoot /var/www/html/blog/backend/public
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
        Options -Indexes +FollowSymLinks
    </Directory>
    
    # Permisos de escritura para storage
    <Directory /var/www/html/blog/backend/storage>
        Require all granted
    </Directory>
    
    # Variables de entorno
    SetEnv APP_ENV local
    SetEnv APP_DEBUG true
    SetEnv APP_URL http://blog-api.local
    
    ErrorLog ${APACHE_LOG_DIR}/blog-api-error.log
    CustomLog ${APACHE_LOG_DIR}/blog-api-access.log combined
</VirtualHost>
```

#### 2. Habilitar sitio y reiniciar Apache

```bash
sudo a2ensite blog-api.conf
sudo a2enmod rewrite
sudo a2enmod headers
sudo systemctl restart apache2
```

#### 3. Agregar al archivo hosts

```bash
# /etc/hosts
127.0.0.1  blog-api.local
```

#### 4. Verificar configuración

```bash
# Probar que responde
curl -I http://blog-api.local/api/home

# Ver rutas de Laravel
# (dentro del contenedor)
php artisan route:list --path=api
```

---

## Producción

### api.chelistico.ar

#### 1. Archivo de configuración Apache con SSL

```bash
# /etc/apache2/sites-available/chelistico-api.conf
<VirtualHost *:80>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
    </Directory>
    
    # Redirección a HTTPS
    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*)$ https://%{SERVER_NAME}/$1 [R=301,L]
    
    ErrorLog ${APACHE_LOG_DIR}/chelistico-api-error.log
    CustomLog ${APACHE_LOG_DIR}/chelistico-api-access.log combined
</VirtualHost>

<VirtualHost *:443>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    # Configuración SSL
    SSLEngine on
    SSLCertificateFile /etc/letsencrypt/live/api.chelistico.ar/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/api.chelistico.ar/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/api.chelistico.ar/chain.pem
    
    # Headers de seguridad
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
    </Directory>
    
    # Headers CORS para el frontend
    Header set Access-Control-Allow-Origin "https://chelistico.ar"
    Header set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"
    
    # Variables de producción
    SetEnv APP_ENV production
    SetEnv APP_DEBUG false
    SetEnv APP_URL https://api.chelistico.ar
    
    # Logs
    ErrorLog ${APACHE_LOG_DIR}/chelistico-api-ssl-error.log
    CustomLog ${APACHE_LOG_DIR}/chelistico-api-ssl-access.log combined
</VirtualHost>
```

#### 2. Habilitar y configurar SSL

```bash
# Habilitar sitio
sudo a2ensite chelistico-api.conf

# Habilitar módulo SSL
sudo a2enmod ssl
sudo a2enmod rewrite
sudo a2enmod headers

# Instalar certificado Let's Encrypt (recomendado)
sudo certbot --apache -d api.chelistico.ar

# O usar certificado existente
# Copiar archivos de certificado a /etc/letsencrypt/live/api.chelistico.ar/

# Reiniciar Apache
sudo systemctl restart apache2
```

#### 3. Verificar con SSL Labs

```
https://www.ssllabs.com/ssltest/analyze.html?d=api.chelistico.ar
```

---

## Configuración PHP-FPM (Opcional)

Si usas PHP-FPM en lugar de mod_php:

```apache
# Agregar al VirtualHost
<FilesMatch \.php$>
    SetHandler "proxy:unix:/var/run/php/php8.4-fpm-blog.sock|fcgi://localhost"
</FilesMatch>
```

---

## Troubleshooting

### Error 403 Forbidden
```bash
# Verificar permisos (dentro del contenedor)
docker exec docker_php84 chown -R www-data:www-data /var/www/html/blog/backend/bootstrap/cache
docker exec docker_php84 chown -R www-data:www-data /var/www/html/blog/backend/storage
docker exec docker_php84 chmod -R 775 /var/www/html/blog/backend/storage
docker exec docker_php84 chmod -R 775 /var/www/html/blog/backend/bootstrap/cache

# Reiniciar Apache
docker exec docker_php84 apachectl -k restart
```

### Error 500 Internal Server Error
```bash
# Ver logs de Laravel (dentro del contenedor)
docker exec docker_php84 sh -c 'cd /var/www/html/blog/backend && tail -f storage/logs/laravel.log'

# Ver logs de Apache
docker exec docker_php84 cat /var/log/apache2/error.log

# Limpiar cachés
docker exec -w /var/www/html/blog/backend docker_php84 php artisan config:clear
docker exec -w /var/www/html/blog/backend docker_php84 php artisan cache:clear
docker exec -w /var/www/html/blog/backend docker_php84 php artisan route:clear
```

### Error "tempnam(): file created in the system's temporary directory"

Este error ocurre cuando PHP no puede escribir en `/tmp`. Solución:

```bash
# 1. Crear archivo de configuración PHP
docker exec docker_php84 sh -c 'echo "[PHP]
sys_temp_dir = /tmp
upload_tmp_dir = /tmp" > /usr/local/etc/php/conf.d/zz-temp.ini'

# 2. Verificar que existe
docker exec docker_php84 cat /usr/local/etc/php/conf.d/zz-temp.ini

# 3. Reiniciar el contenedor
docker restart docker_php84
```

### Error de Conexión a MySQL

```bash
# Verificar que el contenedor MySQL está corriendo
docker ps | grep mysql

# Verificar que se puede conectar desde PHP
docker exec docker_php84 php -r "new PDO('mysql:host=docker_mysql;dbname=techdaily', 'root', 'toor');"

# Verificar que la base de datos existe
docker exec docker_mysql mysql -uroot -ptoor -e "SHOW DATABASES;"

# Crear base de datos si no existe
docker exec docker_mysql mysql -uroot -ptoor -e "CREATE DATABASE IF NOT EXISTS techdaily CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### Verificar Configuración del Proyecto

```bash
# Dentro del contenedor, en /var/www/html/blog/backend
docker exec -w /var/www/html/blog/backend docker_php84 php artisan about

# Ver configuración de la base de datos
docker exec -w /var/www/html/blog/backend docker_php84 php artisan db:show

# Ver estado de migraciones
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate:status
```

### CORS issues
```bash
# Verificar headers en respuesta
curl -I -H "Origin: http://localhost:5173" http://blog-api.local/api/home
# Debería mostrar: Access-Control-Allow-Origin: *
```

### DNS no resuelve (desarrollo)
```bash
# Verificar archivo hosts
cat /etc/hosts | grep blog-api.local

# Si no está, agregar:
sudo bash -c 'echo "127.0.0.1  blog-api.local" >> /etc/hosts'
```

---

## Comandos Rápidos

```bash
# Habilitar sitio
sudo a2ensite blog-api.conf

# Deshabilitar sitio
sudo a2dissite blog-api.conf

# Ver configuración activa
sudo a2dissite 000-default.conf

# Test configuración Apache
sudo apache2ctl configtest

# Reiniciar Apache
sudo systemctl restart apache2

# Status de Apache
sudo systemctl status apache2
```
