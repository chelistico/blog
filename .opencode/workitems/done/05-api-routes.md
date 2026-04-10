# Workitem: 05-api-routes

## Fase 5: Rutas API

### Objetivo
Definir todas las rutas API del backend.

---

## Tasks

### 5.1 Archivo de Rutas
```php
// routes/api.php

use App\Http\Controllers\Api\ArticleController;
use App\Http\Controllers\Api\AuthorController;
use App\Http\Controllers\Api\TagController;
use App\Http\Controllers\Api\SettingController;
use App\Http\Controllers\Api\AdvertisementController;
use App\Http\Controllers\Api\FooterController;
use Illuminate\Support\Facades\Route;

// Rutas públicas
Route::prefix('articles')->group(function () {
    Route::get('/', [ArticleController::class, 'index']);
    Route::get('/search', [ArticleController::class, 'search']);
    Route::get('/by-tag/{tag}', [ArticleController::class, 'byTag']);
    Route::get('/latest', [ArticleController::class, 'latest']);
    Route::get('/popular', [ArticleController::class, 'popular']);
    Route::get('/{id}', [ArticleController::class, 'show']);
});

Route::get('/tags', [TagController::class, 'index']);
Route::get('/tags/{slug}', [TagController::class, 'show']);

Route::get('/authors', [AuthorController::class, 'index']);
Route::get('/authors/{slug}', [AuthorController::class, 'show']);
Route::get('/authors/{slug}/articles', [AuthorController::class, 'articles']);

Route::get('/settings', [SettingController::class, 'index']);

Route::get('/advertisements', [AdvertisementController::class, 'index']);

Route::get('/footer', [FooterController::class, 'index']);

// Rutas de SEO (datos estructurados)
Route::get('/seo/article/{id}', [SeoController::class, 'article']);
Route::get('/seo/website', [SeoController::class, 'website']);
```

### 5.2 Agregar Ruta de Homepage
```php
// En routes/api.php

Route::get('/home', [HomeController::class, 'index']);
```

### 5.3 HomeController (para datos de homepage)
```php
// app/Http/Controllers/Api/HomeController.php

class HomeController extends Controller
{
    public function index()
    {
        $latestArticles = Article::with(['author', 'tags'])
            ->published()
            ->orderByDesc('published_at')
            ->limit(6)
            ->get();
        
        $popularArticles = Article::with(['author', 'tags'])
            ->published()
            ->orderByDesc('views')
            ->limit(4)
            ->get();
        
        $advertisements = Advertisement::active()
            ->whereIn('position', ['top', 'sidebar'])
            ->orderBy('order')
            ->get();
        
        return response()->json([
            'success' => true,
            'data' => [
                'latest_articles' => ArticleResource::collection($latestArticles),
                'popular_articles' => ArticleResource::collection($popularArticles),
                'advertisements' => $advertisements,
                'settings' => $this->getPublicSettings(),
            ]
        ]);
    }
    
    private function getPublicSettings()
    {
        return SiteSetting::whereIn('key', [
            'site_name', 'site_title', 'seo_description', 'logo'
        ])->get()->mapWithKeys(fn($s) => [$s->key => $s->value]);
    }
}
```

### 5.4 SeoController
```php
// app/Http/Controllers/Api/SeoController.php

class SeoController extends Controller
{
    public function article(string $id)
    {
        $article = Article::with(['author', 'tags'])
            ->where('slug', $id)
            ->orWhere('id', $id)
            ->published()
            ->firstOrFail();
        
        $structuredData = [
            '@context' => 'https://schema.org',
            '@type' => 'Article',
            'headline' => $article->title,
            'description' => $article->summary,
            'image' => $article->main_image,
            'datePublished' => $article->published_at?->toIso8601String(),
            'dateModified' => $article->updated_at->toIso8601String(),
            'author' => [
                '@type' => 'Person',
                'name' => $article->author->name,
                'url' => url("/author/{$article->author->slug}")
            ],
            'publisher' => [
                '@type' => 'Organization',
                'name' => SiteSetting::getValue('site_name', 'TechDaily'),
                'logo' => [
                    '@type' => 'ImageObject',
                    'url' => SiteSetting::getValue('logo')
                ]
            ],
            'mainEntityOfPage' => [
                '@type' => 'WebPage',
                '@id' => url("/article/{$article->slug}")
            ]
        ];
        
        return response()->json($structuredData);
    }
    
    public function website()
    {
        $structuredData = [
            '@context' => 'https://schema.org',
            '@type' => 'WebSite',
            'name' => SiteSetting::getValue('site_name', 'TechDaily'),
            'url' => config('app.url'),
            'description' => SiteSetting::getValue('seo_description'),
            'potentialAction' => [
                '@type' => 'SearchAction',
                'target' => [
                    '@type' => 'EntryPoint',
                    'urlTemplate' => url('/search?q={search_term_string}')
                ],
                'query-input' => 'required name=search_term_string'
            ]
        ];
        
        return response()->json($structuredData);
    }
}
```

### 5.5 Actualizar bootstrap/app.php
```php
// bootstrap/app.php

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->api(prepend: [
            \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
        ]);
    })
    ->create();
```

---

## Lista Completa de Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | /api/articles | Listar artículos (paginado) |
| GET | /api/articles/{id} | Ver artículo |
| GET | /api/articles/search | Buscar artículos |
| GET | /api/articles/by-tag/{tag} | Artículos por tag |
| GET | /api/articles/latest | Últimos artículos |
| GET | /api/articles/popular | Artículos populares |
| GET | /api/tags | Listar tags |
| GET | /api/tags/{slug} | Ver tag |
| GET | /api/authors | Listar autores |
| GET | /api/authors/{slug} | Ver autor |
| GET | /api/authors/{slug}/articles | Artículos de autor |
| GET | /api/settings | Configuraciones públicas |
| GET | /api/advertisements | Anuncios activos |
| GET | /api/footer | Items del footer |
| GET | /api/home | Datos para homepage |
| GET | /api/seo/article/{id} | Structured data artículo |
| GET | /api/seo/website | Structured data website |

---

## Verificación
- [ ] Rutas definidas en api.php
- [ ] Probar con `php artisan route:list --path=api`
- [ ] Verificar que todos los endpoints respondan correctamente

---

### 5.6 Configuración de CORS para Desarrollo

```php
// config/cors.php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['http://localhost:5173', 'http://blog-api.local'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => true,
];
```

**Producción:** Actualizar `allowed_origins` con `https://chelistico.ar`

---

## Siguiente Paso
Ver [06-media-management.md](./06-media-management.md) para la gestión de medios/imágenes.
