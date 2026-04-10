# Workitem: 01-initial-setup

## Fase 1: Configuración Inicial del Proyecto Laravel 12

### Objetivo
Crear y configurar el proyecto Laravel 12 en la carpeta `backend/`.

---

## Tasks

### 1.1 Crear Proyecto Laravel
```bash
composer create-project laravel/laravel backend
cd backend
composer require laravel/sanctum
```

### 1.2 Configurar .env
```bash
cp .env.example .env
php artisan key:generate
```
- Configurar conexión a base de datos
- Configurar URL base (`APP_URL=http://blog-api.local`)
- Configurar almacenamiento de imágenes (`FILESYSTEM_DISK=public`)

**Desarrollo (Docker):**
```env
DB_HOST=docker_mysql
DB_DATABASE=techdaily
DB_USERNAME=root
DB_PASSWORD=secret
```

**Producción:**
```env
DB_HOST=your_production_host
DB_DATABASE=techdaily
DB_USERNAME=your_user
DB_PASSWORD=your_secure_password
APP_URL=https://api.chelistico.ar
```

### 1.3 Crear Symbolic Link para Storage
```bash
php artisan storage:link
```

### 1.4 Instalar Dependencias Necesarias
```bash
composer require intervention/image-laravel
composer require spatie/laravel-sluggable
```

### 1.5 Configurar Timezone y Locale
En `config/app.php`:
```php
'timezone' => 'America/Argentina/Buenos_Aires',
'locale' => 'es',
'fallback_locale' => 'es',
```

### 1.6 Crear Directorio de Estructura
```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/Api/
│   │   ├── Resources/
│   │   └── Requests/
│   ├── Models/
│   └── Services/
├── database/
│   └── migrations/
├── routes/
│   └── api.php
└── ...
```

### 1.7 Configurar API Resources en bootstrap
En `bootstrap/app.php`, agregar:
```php
->withRouting(
    api: __DIR__.'/../routes/api.php',
    // ...
)
```

### 1.8 Configurar CORS
En `config/cors.php`:
```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_methods' => ['*'],
'allowed_origins' => ['http://localhost:5173'], // Frontend URL
'allowed_origins_patterns' => [],
'allowed_headers' => ['*'],
'supports_credentials' => true,
```

---

## Verificación
- [ ] Proyecto Laravel creado exitosamente
- [ ] Dependencias instaladas
- [ ] Base de datos conectada
- [ ] Storage link creado
- [ ] CORS configurado

---

## Siguiente Paso
Ver [02-models-migrations.md](./02-models-migrations.md) para crear los modelos y migraciones.
