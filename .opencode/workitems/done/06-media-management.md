# Workitem: 06-media-management

## Fase 6: Gestión de Medios e Imágenes

### Objetivo
Implementar sistema de subida y gestión de imágenes (logos, favicon, imágenes de artículos).

---

## Tasks

### 6.1 Crear Controlador de Upload
```php
// app/Http/Controllers/Api/UploadController.php

class UploadController extends Controller
{
    public function image(Request $request)
    {
        $request->validate([
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,webp|max:5120',
            'folder' => 'nullable|string|in:articles,avatars,settings,banners'
        ]);
        
        $path = $request->file('image')->store(
            'images/' . ($request->folder ?? 'misc'),
            'public'
        );
        
        return response()->json([
            'success' => true,
            'data' => [
                'url' => Storage::url($path),
                'path' => $path
            ]
        ]);
    }
    
    public function delete(Request $request)
    {
        $request->validate([
            'path' => 'required|string'
        ]);
        
        $fullPath = str_replace('/storage/', '', $request->path);
        
        if (Storage::disk('public')->exists($fullPath)) {
            Storage::disk('public')->delete($fullPath);
            return response()->json(['success' => true, 'message' => 'Archivo eliminado']);
        }
        
        return response()->json(['success' => false, 'message' => 'Archivo no encontrado'], 404);
    }
}
```

### 6.2 Crear Intervener para Optimización de Imágenes
```php
// app/Models/Concerns/HasImageProcessing.php

trait HasImageProcessing
{
    public static function bootHasImageProcessing()
    {
        static::updating(function ($model) {
            // Optimizar al guardar
        });
    }
}
```

### 6.3 Configurar Intervention Image
```php
// config/image.php

return [
    'driver' => 'gd', // o 'imagick'
];
```

### 6.4 Agregar Ruta de Upload
```php
// En routes/api.php

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/upload/image', [UploadController::class, 'image']);
    Route::delete('/upload/image', [UploadController::class, 'delete']);
});
```

### 6.5 Policy para Archivos
```php
// app/Policies/MediaPolicy.php

class MediaPolicy
{
    public function upload(User $user): bool
    {
        return $user->isAdmin();
    }
    
    public function delete(User $user): bool
    {
        return $user->isAdmin();
    }
}
```

### 6.6 Tipos de Imágenes Permitidas
```php
// config/filesystems.php disks

'public' => [
    'driver' => 'local',
    'root' => storage_path('app/public'),
    'url' => env('APP_URL').'/storage',
    'visibility' => 'public',
    'strip' => [],
    'paranoid' => false,
    'throw' => false,
],
```

### 6.7 Estructura de Carpetas Sugerida
```
storage/app/public/
├── images/
│   ├── articles/
│   │   ├── 2025/
│   │   │   ├── 09/
│   │   │   │   ├── article-1-main.jpg
│   │   │   │   └── article-1-embedded-1.jpg
│   ├── avatars/
│   │   └── author-1.jpg
│   ├── settings/
│   │   ├── logo.png
│   │   ├── logo-light.png
│   │   └── favicon.ico
│   └── banners/
│       ├── top-banner.jpg
│       └── sidebar-banner.png
```

### 6.8 Servicio de Limpieza
```php
// app/Services/MediaCleanupService.php

class MediaCleanupService
{
    public function cleanupOrphanedImages()
    {
        // Encontrar imágenes no referenciadas en artículos
        $allImages = Storage::disk('public')
            ->allFiles('images/articles');
        
        $referencedImages = Article::all()
            ->flatMap(fn($a) => array_merge(
                [$a->main_image],
                $a->embedded_images ?? []
            ))
            ->filter();
        
        $orphaned = collect($allImages)->reject(
            fn($img) => $referencedImages->contains(fn($ref) => str_contains($ref, basename($img)))
        );
        
        return $orphaned;
    }
}
```

---

## Verificación
- [ ] UploadController creado
- [ ] Ruta de upload configurada
- [ ] Validaciones configuradas
- [ ] Storage link funcional
- [ ] Permisos configurados

---

## Siguiente Paso
Ver [07-authentication.md](./07-authentication.md) para el sistema de autenticación.
