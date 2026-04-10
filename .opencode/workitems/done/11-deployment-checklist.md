# Workitem: 11-deployment-checklist

## Deployment Checklist

### URLs del Proyecto

| Entorno | Frontend | Backend API |
|---------|----------|-------------|
| Desarrollo | http://localhost:5173 | http://blog-api.local/api |
| Producción | https://chelistico.ar | https://api.chelistico.ar/api |

### Configuración de Virtual Hosts

#### Desarrollo (blog-api.local)
```apache
<VirtualHost *:80>
    ServerName blog-api.local
    DocumentRoot /var/www/html/blog/backend/public
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

#### Producción (api.chelistico.ar)
```apache
<VirtualHost *:443>
    ServerName api.chelistico.ar
    DocumentRoot /var/www/html/blog/backend/public
    
    SSLEngine on
    SSLCertificateFile /path/to/fullchain.pem
    SSLCertificateKeyFile /path/to/privkey.pem
    
    <Directory /var/www/html/blog/backend/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

**Agregar en /etc/hosts (desarrollo):**
```
127.0.0.1  blog-api.local
```

### Pre-Deploy

- [ ] Tests pasando: `php artisan test`
- [ ] Typecheck (si aplica): `php artisan route:list --path=api`
- [ ] .env configurado correctamente
- [ ] Migraciones ejecutadas en producción
- [ ] Seeders ejecutados

### Configuración de Producción

#### .env Production
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.chelistico.ar

DB_CONNECTION=mysql
DB_HOST=your_production_mysql_host
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=your_user
DB_PASSWORD=your_secure_password

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

FILESYSTEM_DISK=public
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,api.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar
```

#### Frontend .env (Producción)
```bash
VITE_API_BASE_URL=https://api.chelistico.ar/api
```

### Base de Datos

**Desarrollo:**
- Contenedor: `docker_mysql`
- Host Laravel: `docker_mysql:3306`
- Host herramientas locales: `localhost:3306`

**Producción:**
- MySQL server dedicado o cloud (AWS RDS, DigitalOcean, etc.)

#### Storage Link
```bash
php artisan storage:link
```

### Rutas API Finales

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| /api/articles | GET | Listar artículos |
| /api/articles/{id} | GET | Ver artículo |
| /api/articles/search | GET | Buscar |
| /api/articles/by-tag/{tag} | GET | Por tag |
| /api/articles/latest | GET | Últimos |
| /api/articles/popular | GET | Populares |
| /api/tags | GET | Tags |
| /api/authors | GET | Autores |
| /api/authors/{slug}/articles | GET | Artículos autor |
| /api/settings | GET | Configuraciones |
| /api/advertisements | GET | Anuncios |
| /api/footer | GET | Footer |
| /api/home | GET | Homepage data |
| /api/seo/article/{id} | GET | JSON-LD artículo |
| /api/seo/website | GET | JSON-LD website |
| /api/auth/register | POST | Registro |
| /api/auth/login | POST | Login |
| /api/auth/logout | POST | Logout |
| /api/auth/me | GET | Usuario actual |
| /api/admin/articles | CRUD | Admin artículos |
| /api/admin/tags | CRUD | Admin tags |
| /api/admin/authors | CRUD | Admin autores |
| /api/admin/advertisements | CRUD | Admin ads |
| /api/admin/footer | CRUD | Admin footer |
| /api/admin/settings | GET/PUT | Admin settings |

---

## Archivos de Referencia

1. [00-plan-overview.md](./00-plan-overview.md) - Vista general
2. [01-initial-setup.md](./01-initial-setup.md) - Setup inicial
3. [02-models-migrations.md](./02-models-migrations.md) - Modelos y migraciones
4. [03-api-controllers.md](./03-api-controllers.md) - Controladores API
5. [04-api-resources.md](./04-api-resources.md) - API Resources
6. [05-api-routes.md](./05-api-routes.md) - Rutas
7. [06-media-management.md](./06-media-management.md) - Gestión de medios
8. [07-authentication.md](./07-authentication.md) - Autenticación
9. [08-content-management.md](./08-content-management.md) - Gestión contenido
10. [09-seo-ads-integration.md](./09-seo-ads-integration.md) - SEO y Ads
11. [10-testing.md](./10-testing.md) - Testing
