# Workitem: 03-api-controllers

## Fase 3: Controladores API

### Objetivo
Crear todos los controladores API para gestionar las entidades del blog.

---

## Tasks

### 3.1 ArticleController
```php
// app/Http/Controllers/Api/ArticleController.php

class ArticleController extends Controller
{
    // GET /api/articles
    public function index(Request $request)
    {
        $query = Article::with(['author', 'tags'])
            ->published()
            ->orderByDesc('published_at');
        
        // Filtros
        if ($request->has('tag')) {
            $query->whereHas('tags', fn($q) => $q->where('slug', $request->tag));
        }
        
        if ($request->has('author')) {
            $query->whereHas('author', fn($q) => $q->where('slug', $request->author));
        }
        
        $articles = $query->paginate($request->get('per_page', 10));
        
        return ArticleResource::collection($articles);
    }
    
    // GET /api/articles/{id}
    public function show(string $id)
    {
        $article = Article::with(['author', 'tags'])
            ->where('slug', $id)
            ->orWhere('id', $id)
            ->published()
            ->firstOrFail();
        
        // Incrementar vistas
        $article->increment('views');
        
        return new ArticleResource($article);
    }
    
    // GET /api/articles/search?q=
    public function search(Request $request)
    {
        $query = Article::with(['author', 'tags'])
            ->published()
            ->where(function ($q) use ($request) {
                $q->where('title', 'LIKE', "%{$request->q}%")
                  ->orWhere('summary', 'LIKE', "%{$request->q}%")
                  ->orWhere('content', 'LIKE', "%{$request->q}%");
            });
        
        $articles = $query->paginate($request->get('per_page', 10));
        
        return ArticleResource::collection($articles);
    }
    
    // GET /api/articles/by-tag/{tag}
    public function byTag(string $tag)
    {
        $articles = Article::with(['author', 'tags'])
            ->whereHas('tags', fn($q) => $q->where('slug', $tag))
            ->published()
            ->orderByDesc('published_at')
            ->paginate(10);
        
        return ArticleResource::collection($articles);
    }
    
    // GET /api/articles/latest
    public function latest(Request $request)
    {
        $articles = Article::with(['author', 'tags'])
            ->published()
            ->orderByDesc('published_at')
            ->limit($request->get('limit', 5))
            ->get();
        
        return ArticleResource::collection($articles);
    }
    
    // GET /api/articles/popular
    public function popular(Request $request)
    {
        $articles = Article::with(['author', 'tags'])
            ->published()
            ->orderByDesc('views')
            ->limit($request->get('limit', 5))
            ->get();
        
        return ArticleResource::collection($articles);
    }
}
```

### 3.2 TagController
```php
// app/Http/Controllers/Api/TagController.php

class TagController extends Controller
{
    // GET /api/tags
    public function index()
    {
        $tags = Tag::withCount('articles')->get();
        return TagResource::collection($tags);
    }
    
    // GET /api/tags/{slug}
    public function show(string $slug)
    {
        $tag = Tag::where('slug', $slug)->firstOrFail();
        return new TagResource($tag);
    }
}
```

### 3.3 AuthorController
```php
// app/Http/Controllers/Api/AuthorController.php

class AuthorController extends Controller
{
    // GET /api/authors
    public function index()
    {
        $authors = Author::where('is_active', true)->get();
        return AuthorResource::collection($authors);
    }
    
    // GET /api/authors/{slug}
    public function show(string $slug)
    {
        $author = Author::where('slug', $slug)->firstOrFail();
        return new AuthorResource($author);
    }
    
    // GET /api/authors/{slug}/articles
    public function articles(string $slug, Request $request)
    {
        $author = Author::where('slug', $slug)->firstOrFail();
        
        $articles = $author->articles()
            ->with(['author', 'tags'])
            ->published()
            ->orderByDesc('published_at')
            ->paginate(10);
        
        return ArticleResource::collection($articles);
    }
}
```

### 3.4 SettingController
```php
// app/Http/Controllers/Api/SettingController.php

class SettingController extends Controller
{
    // GET /api/settings
    public function index()
    {
        $settings = SiteSetting::all()->groupBy('group');
        
        return response()->json([
            'success' => true,
            'data' => [
                'branding' => $this->formatSettings($settings->get('branding', collect())),
                'seo' => $this->formatSettings($settings->get('seo', collect())),
                'social' => $this->formatSettings($settings->get('social', collect())),
            ]
        ]);
    }
    
    private function formatSettings($settings)
    {
        return $settings->mapWithKeys(fn($s) => [$s->key => $this->castValue($s->value, $s->type)]);
    }
    
    private function castValue($value, $type)
    {
        return match($type) {
            'json' => json_decode($value, true),
            'boolean' => filter_var($value, FILTER_VALIDATE_BOOLEAN),
            default => $value
        };
    }
}
```

### 3.5 AdvertisementController
```php
// app/Http/Controllers/Api/AdvertisementController.php

class AdvertisementController extends Controller
{
    // GET /api/advertisements
    public function index(Request $request)
    {
        $position = $request->get('position');
        
        $query = Advertisement::active()->orderBy('order');
        
        if ($position) {
            $query->where('position', $position);
        }
        
        $advertisements = $query->get();
        
        return AdvertisementResource::collection($advertisements);
    }
}
```

### 3.6 FooterController
```php
// app/Http/Controllers/Api/FooterController.php

class FooterController extends Controller
{
    // GET /api/footer
    public function index()
    {
        $footer = FooterItem::active()
            ->orderBy('section')
            ->orderBy('order')
            ->get()
            ->groupBy('section');
        
        return response()->json([
            'success' => true,
            'data' => $footer
        ]);
    }
}
```

---

## Verificación
- [ ] ArticleController creado con todos los métodos
- [ ] TagController creado
- [ ] AuthorController creado
- [ ] SettingController creado
- [ ] AdvertisementController creado
- [ ] FooterController creado

---

## Siguiente Paso
Ver [04-api-resources.md](./04-api-resources.md) para crear los API Resources (transformers).
