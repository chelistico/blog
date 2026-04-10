# Workitem: 13-filament-installation

## Fase 1: Instalación de Filament

### Objetivo
Instalar y configurar Filament v3 en el proyecto Laravel.

---

## Tasks

### 1.1 Instalar Filament

```bash
# Dentro del contenedor docker_php84
docker exec -w /var/www/html/blog/backend docker_php84 composer require filament/filament:"^3.2" -W
```

### 1.2 Publicar recursos de Filament

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan filament:install --panels
```

### 1.3 Crear panel de administración

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-panel admin
```

### 1.4 Configurar el panel en bootstrap

En `bootstrap/app.php`, agregar el provider del panel:

```php
->withProviders([
    App\Providers\Filament\AdminPanelProvider::class,
])
```

### 1.5 Configurar navegación del panel

Editar `app/Providers/Filament/AdminPanelProvider.php`:

```php
<?php

namespace App\Providers\Filament;

use Filament\Panel;
use Filament\PanelProvider;

class AdminPanelProvider extends PanelProvider
{
    public function panel(Panel $panel): Panel
    {
        return $panel
            ->default()
            ->id('admin')
            ->path('admin')
            ->login()
            ->colors([
                'primary' => Color::Amber,
            ])
            ->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
            ->discoverPages(in: app_path('Filament/Pages'), for: 'App\\Filament\\Pages')
            ->discoverWidgets(in: app_path('Filament/Widgets'), for: 'App\\Filament\\Widgets')
            ->widgets([
                Widgets\AccountWidget::class,
                Widgets\FilamentInfoWidget::class,
            ])
            ->middleware([
                ConfigureSidebar::class,
            ]);
    }
}
```

### 1.6 Verificar instalación

```bash
# Probar que el panel está accesible
curl -I http://blog-api.local/admin
```

### 1.7 Configurar autenticación

Filament incluye autenticación lista para usar. Verificar que el modelo User tiene los traits necesarios:

```bash
# En app/Models/User.php, verificar que existe:
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens;
    // ...
}
```

### 1.8 Crear usuario administrador inicial

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-user
# Follow the prompts
```

O usar el seeder existente:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan db:seed --class=AdminUserSeeder
```

---

## Verificación

- [ ] Filament instalado exitosamente
- [ ] Panel accesible en /admin
- [ ] Login funcionando
- [ ] Usuario admin puede acceder

---

## Siguiente Paso
Ver [14-filament-resources-base.md](./14-filament-resources-base.md) para crear los recursos básicos.
