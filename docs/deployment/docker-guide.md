# Guía de Docker - TechDaily Blog

## Contenedores del Proyecto

| Contenedor | Servicio | Puerto | Propósito |
|------------|----------|--------|-----------|
| `docker_php84` | Apache + PHP 8.4 | 80, 443 | Servidor web Backend |
| `docker_mysql` | MySQL 8.x | 3306 | Base de datos |

## Estructura de Red

```
┌─────────────────────────────────────────────────────────────┐
│                     Red Docker                              │
│                                                              │
│   ┌─────────────────────┐     ┌──────────────────────┐    │
│   │   docker_php84       │     │   docker_mysql       │    │
│   │                      │     │                      │    │
│   │   /var/www/html/     │────▶│   MySQL              │    │
│   │     blog/backend/    │     │   Host: docker_mysql  │    │
│   │                      │     │   Port: 3306          │    │
│   └─────────────────────┘     └──────────────────────┘    │
│                                                              │
│   Expueto en puerto 80 del host                              │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Acceso a los Contenedores

```bash
# Shell interactivo en PHP
docker exec -it docker_php84 bash

# Shell interactivo en MySQL
docker exec -it docker_mysql mysql -uroot -ptoor

# Ejecutar comando sin shell interactiva
docker exec docker_php84 php -v
docker exec docker_mysql mysql -uroot -ptoor -e "SELECT 1;"
```

## Comandos Laravel en el Contenedor

```bash
# Navegar al proyecto
docker exec -w /var/www/html/blog/backend docker_php84 php artisan --version

# Limpiar cachés
docker exec -w /var/www/html/blog/backend docker_php84 php artisan config:clear
docker exec -w /var/www/html/blog/backend docker_php84 php artisan cache:clear
docker exec -w /var/www/html/blog/backend docker_php84 php artisan route:clear
docker exec -w /var/www/html/blog/backend docker_php84 php artisan view:clear

# Migraciones
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate:fresh
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate:status

# Seeders
docker exec -w /var/www/html/blog/backend docker_php84 php artisan db:seed

# Ver rutas
docker exec -w /var/www/html/blog/backend docker_php84 php artisan route:list

# Información del proyecto
docker exec -w /var/www/html/blog/backend docker_php84 php artisan about

# Instalar dependencias
docker exec -w /var/www/html/blog/backend docker_php84 composer install
docker exec -w /var/www/html/blog/backend docker_php84 npm install
```

## Configuración de MySQL

### Credenciales

| Parámetro | Valor |
|-----------|-------|
| Host | `docker_mysql` |
| Usuario | `root` |
| Contraseña | `toor` |
| Puerto | `3306` |
| Base de datos | `techdaily` |

### Verificar credenciales

```bash
# Ver variables de entorno del contenedor MySQL
docker inspect docker_mysql --format='{{range .Config.Env}}{{println .}}{{end}}' | grep MYSQL
```

### Operaciones de Base de Datos

```bash
# Conectar a MySQL
docker exec -it docker_mysql mysql -uroot -ptoor

# Ver bases de datos
docker exec docker_mysql mysql -uroot -ptoor -e "SHOW DATABASES;"

# Seleccionar base de datos
docker exec docker_mysql mysql -uroot -ptoor techdaily -e "SHOW TABLES;"

# Crear base de datos
docker exec docker_mysql mysql -uroot -ptoor -e "CREATE DATABASE techdaily CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Ver usuarios
docker exec docker_mysql mysql -uroot -ptoor -e "SELECT user, host FROM mysql.user;"

# Crear usuario para producción
docker exec docker_mysql mysql -uroot -ptoor -e "CREATE USER 'techdaily'@'%' IDENTIFIED BY 'tu_password_seguro';"
docker exec docker_mysql mysql -uroot -ptoor -e "GRANT ALL PRIVILEGES ON techdaily.* TO 'techdaily'@'%';"
docker exec docker_mysql mysql -uroot -ptoor -e "FLUSH PRIVILEGES;"
```

## Reiniciar Servicios

```bash
# Reiniciar contenedor PHP
docker restart docker_php84

# Reiniciar MySQL
docker restart docker_mysql

# Ver logs de PHP/Apache
docker logs -f docker_php84

# Ver logs de MySQL
docker logs -f docker_mysql
```

## Troubleshooting Docker

### El contenedor no inicia

```bash
# Ver estado de todos los contenedores
docker ps -a

# Ver logs del contenedor
docker logs docker_php84
docker logs docker_mysql

# Inspeccionar configuración
docker inspect docker_php84
```

### Cambios en archivos no se reflejan

```bash
# Verificar que los archivos están montados
docker exec docker_php84 ls -la /var/www/html/blog/backend

# Si no están montados, copiar archivos
docker cp ./backend/. docker_php84:/var/www/html/blog/backend/
```

### Permisos de archivos

```bash
# Corregir permisos para Apache
docker exec docker_php84 chown -R www-data:www-data /var/www/html/blog/backend/bootstrap/cache
docker exec docker_php84 chown -R www-data:www-data /var/www/html/blog/backend/storage
docker exec docker_php84 chmod -R 775 /var/www/html/blog/backend/storage
docker exec docker_php84 chmod -R 775 /var/www/html/blog/backend/bootstrap/cache

# Limpiar cachés de Laravel
docker exec -w /var/www/html/blog/backend docker_php84 php artisan config:cache
docker exec -w /var/www/html/blog/backend docker_php84 php artisan route:cache
```

### Configuración PHP personalizada

```bash
# Ver configuración PHP
docker exec docker_php84 php -i | grep -E "upload_max_filesize|post_max_size|memory_limit"

# Modificar límites de PHP (crear archivo de configuración)
docker exec docker_php84 sh -c 'echo "[PHP]
upload_max_filesize = 20M
post_max_size = 25M
memory_limit = 256M
sys_temp_dir = /tmp
upload_tmp_dir = /tmp" > /usr/local/etc/php/conf.d/zz-custom.ini'

# Reiniciar para aplicar cambios
docker restart docker_php84
```

## Preparación para Producción

### 1. Verificar que funciona en desarrollo
```bash
curl http://blog-api.local/
curl http://blog-api.local/api/home
```

### 2. Hacer backup de la base de datos
```bash
docker exec docker_mysql mysqldump -uroot -ptoor techdaily > backup_$(date +%Y%m%d).sql
```

### 3. Actualizar variables de producción
Editar `.env` con los valores de producción:
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.chelistico.ar

DB_HOST=tu_servidor_mysql_produccion
DB_DATABASE=techdaily
DB_USERNAME=tu_usuario_produccion
DB_PASSWORD=tu_password_seguro
```

### 4. Ejecutar en el servidor de producción
```bash
# En el servidor de producción
composer install --optimize
php artisan migrate --force
php artisan db:seed
php artisan config:cache
php artisan route:cache
php artisan view:cache
```
