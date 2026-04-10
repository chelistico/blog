# Workitem: 17-filament-customization

## Fase 5: Personalización y Branding

### Objetivo
Personalizar el panel admin con el branding de TechDaily.

---

## Tasks

### 5.1 Configurar colores y branding

En `app/Providers/Filament/AdminPanelProvider.php`:

```php
public function panel(Panel $panel): Panel
{
    return $panel
        ->default()
        ->id('admin')
        ->path('admin')
        ->login()
        ->brandLogo(asset('images/logo.png'))
        ->brandName('TechDaily Admin')
        ->brandLogoHeight('2rem')
        ->colors([
            'primary' => Color::Amber,
            'secondary' => Color::Zinc,
            'gray' => Color::Slate,
            'danger' => Color::Rose,
            'warning' => Color::Orange,
            'success' => Color::Emerald,
            'info' => Color::Sky,
        ])
        ->font('Inter')
        ->renderHook(
            PanelsRenderHook::SIDEBAR_FOOTER,
            fn (): View => view('filament.admin.sidebar-footer'),
        );
}
```

### 5.2 Tema personalizado

Crear archivo de tema:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-theme
```

Personalizar en `resources/css/filament/admin/theme.css`:

```css
@import "../../../../vendor/filament/filament/resources/css/theme.css";

@config "tailwind.config.js";

:root {
    --primary: 245 158 11; /* Amber 500 */
    --primary-dark: 217 119 6; /* Amber 600 */
}
```

### 5.3 Recursos de imágenes

Copiar logo a `public/images/logo.png`

```bash
# Crear directorio si no existe
docker exec docker_php84 mkdir -p /var/www/html/blog/backend/public/images
```

### 5.4 Mensaje de bienvenida personalizado

Modificar la página de login:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan vendor:publish --tag=filament-actions --force
```

Editar `resources/views/filament/login.blade.php`.

### 5.5 Footer personalizado del sidebar

Crear `resources/views/filament/admin/sidebar-footer.blade.php`:

```blade
<div class="flex items-center justify-between px-4 py-2 border-t border-gray-700">
    <span class="text-xs text-gray-400">
        TechDaily v1.0
    </span>
    <a 
        href="/" 
        target="_blank" 
        class="text-xs text-gray-400 hover:text-white flex items-center gap-1"
    >
        Ver sitio
        <x-heroicon-m-arrow-top-right-on-square class="w-3 h-3" />
    </a>
</div>
```

### 5.6 Ocultar recursos del menú

Si no queremos que todos los recursos estén en el menú:

```php
// En AdminPanelProvider.php
->resources([
    config('filament.resource_configs'),
])
```

O usar `->hiddenResources()`.

### 5.7 Configurar búsqueda global

Habilitar búsqueda en el header:

```php
->topNavigation()
->globalSearch(true)
->globalSearchField()
```

### 5.8 Notificaciones

Configurar notificaciones para acciones importantes.

---

## Verificación

- [ ] Logo de TechDaily visible
- [ ] Colores aplicados
- [ ] Footer personalizado
- [ ] Branding consistente

---

## Siguiente Paso
Ver [18-filament-verification.md](./18-filament-verification.md) para verificación final.
