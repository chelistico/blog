# Workitem: 08-content-management

## Fase 8: Gestión de Contenido (Panel Admin API)

### Objetivo
Crear endpoints CRUD completos para gestionar todo el contenido del blog.

---

## Tasks

### 8.1 AdminArticleController
```php
// app/Http/Controllers/Admin/AdminArticleController.php

class AdminArticleController extends Controller
{
    public function index(Request $request)
    {
        $query = Article::with(['author', 'tags']);
        
        if ($request->has('status')) {
            match($request->status) {
                'published' => $query->where('is_published', true),
                'draft' => $query->where('is_published', false),
                'scheduled' => $query->where('published_at', '>', now()),
                default => null
            };
        }
        
        $articles = $query->orderByDesc('created_at')->paginate(20);
        
        return AdminArticleResource::collection($articles);
    }
    
    public function store(StoreArticleRequest $request)
    {
        $data = $request->validated();
        $data['slug'] = Str::slug($data['title']);
        $data['author_id'] = $request->user()->id;
        
        if (!isset($data['read_time'])) {
            $data['read_time'] = $this->calculateReadTime($data['content']);
        }
        
        $article = Article::create($data);
        
        if (isset($data['tags'])) {
            $article->tags()->attach($data['tags']);
        }
        
        return response()->json([
            'success' => true,
            'data' => new ArticleResource($article->load(['author', 'tags']))
        ], 201);
    }
    
    public function update(UpdateArticleRequest $request, Article $article)
    {
        $data = $request->validated();
        
        if (isset($data['title'])) {
            $data['slug'] = Str::slug($data['title']);
        }
        
        if (isset($data['tags'])) {
            $article->tags()->sync($data['tags']);
        }
        
        $article->update($data);
        
        return response()->json([
            'success' => true,
            'data' => new ArticleResource($article->fresh(['author', 'tags']))
        ]);
    }
    
    public function destroy(Article $article)
    {
        $article->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Artículo eliminado'
        ]);
    }
    
    private function calculateReadTime(string $content): int
    {
        $wordCount = str_word_count(strip_tags($content));
        return max(1, (int) ceil($wordCount / 200)); // 200 palabras por minuto
    }
}
```

### 8.2 Form Requests para Articles
```php
// app/Http/Requests/StoreArticleRequest.php

class StoreArticleRequest extends FormRequest
{
    public function rules(): array
    {
        return [
            'title' => 'required|string|max:255',
            'summary' => 'required|string|max:500',
            'content' => 'required|string',
            'main_image' => 'nullable|string',
            'embedded_images' => 'nullable|array',
            'embedded_images.*' => 'string',
            'video_url' => 'nullable|url',
            'tags' => 'nullable|array',
            'tags.*' => 'exists:tags,id',
            'published_at' => 'nullable|date',
            'is_published' => 'boolean',
        ];
    }
}
```

### 8.3 AdminTagController
```php
// app/Http/Controllers/Admin/AdminTagController.php

class AdminTagController extends Controller
{
    public function index()
    {
        $tags = Tag::withCount('articles')->orderBy('name')->get();
        return TagResource::collection($tags);
    }
    
    public function store(StoreTagRequest $request)
    {
        $tag = Tag::create($request->validated());
        return response()->json(['success' => true, 'data' => new TagResource($tag)], 201);
    }
    
    public function update(StoreTagRequest $request, Tag $tag)
    {
        $tag->update($request->validated());
        return response()->json(['success' => true, 'data' => new TagResource($tag)]);
    }
    
    public function destroy(Tag $tag)
    {
        if ($tag->articles()->count() > 0) {
            return response()->json([
                'success' => false,
                'error' => ['code' => 'HAS_ARTICLES', 'message' => 'El tag tiene artículos asociados']
            ], 422);
        }
        
        $tag->delete();
        return response()->json(['success' => true, 'message' => 'Tag eliminado']);
    }
}
```

### 8.4 AdminAuthorController
```php
// app/Http/Controllers/Admin/AdminAuthorController.php

class AdminAuthorController extends Controller
{
    public function index(Request $request)
    {
        $query = Author::withCount('articles');
        
        if ($request->has('active')) {
            $query->where('is_active', filter_var($request->active, FILTER_VALIDATE_BOOLEAN));
        }
        
        $authors = $query->orderBy('name')->paginate(20);
        
        return AuthorResource::collection($authors);
    }
    
    public function store(StoreAuthorRequest $request)
    {
        $data = $request->validated();
        $data['slug'] = Str::slug($data['name']);
        
        if (isset($data['social_links'])) {
            $data['social_links'] = json_encode($data['social_links']);
        }
        
        $author = Author::create($data);
        
        return response()->json(['success' => true, 'data' => new AuthorResource($author)], 201);
    }
    
    public function update(StoreAuthorRequest $request, Author $author)
    {
        $data = $request->validated();
        
        if (isset($data['name'])) {
            $data['slug'] = Str::slug($data['name']);
        }
        
        if (isset($data['social_links'])) {
            $data['social_links'] = json_encode($data['social_links']);
        }
        
        $author->update($data);
        
        return response()->json(['success' => true, 'data' => new AuthorResource($author)]);
    }
    
    public function destroy(Author $author)
    {
        if ($author->articles()->count() > 0) {
            return response()->json([
                'success' => false,
                'error' => ['code' => 'HAS_ARTICLES', 'message' => 'El autor tiene artículos asociados']
            ], 422);
        }
        
        $author->delete();
        return response()->json(['success' => true, 'message' => 'Autor eliminado']);
    }
}
```

### 8.5 AdminSettingController
```php
// app/Http/Controllers/Admin/AdminSettingController.php

class AdminSettingController extends Controller
{
    public function index(Request $request)
    {
        $query = SiteSetting::query();
        
        if ($request->has('group')) {
            $query->where('group', $request->group);
        }
        
        $settings = $query->orderBy('group')->orderBy('key')->get();
        
        return response()->json([
            'success' => true,
            'data' => $settings
        ]);
    }
    
    public function update(Request $request)
    {
        $validated = $request->validate([
            'key' => 'required|string|exists:site_settings,key',
            'value' => 'nullable',
        ]);
        
        $setting = SiteSetting::where('key', $validated['key'])->first();
        $setting->update(['value' => $validated['value']]);
        
        return response()->json([
            'success' => true,
            'data' => $setting
        ]);
    }
    
    public function updateMultiple(Request $request)
    {
        $validated = $request->validate([
            'settings' => 'required|array',
            'settings.*.key' => 'required|string|exists:site_settings,key',
            'settings.*.value' => 'nullable',
        ]);
        
        foreach ($validated['settings'] as $item) {
            SiteSetting::where('key', $item['key'])->update(['value' => $item['value']]);
        }
        
        return response()->json(['success' => true, 'message' => 'Configuraciones actualizadas']);
    }
}
```

### 8.6 AdminAdvertisementController
```php
// app/Http/Controllers/Admin/AdminAdvertisementController.php

class AdminAdvertisementController extends Controller
{
    public function index(Request $request)
    {
        $query = Advertisement::query();
        
        if ($request->has('position')) {
            $query->where('position', $request->position);
        }
        
        if ($request->has('active')) {
            $query->where('is_active', filter_var($request->active, FILTER_VALIDATE_BOOLEAN));
        }
        
        $advertisements = $query->orderBy('position')->orderBy('order')->get();
        
        return AdvertisementResource::collection($advertisements);
    }
    
    public function store(StoreAdvertisementRequest $request)
    {
        $advertisement = Advertisement::create($request->validated());
        
        return response()->json([
            'success' => true,
            'data' => new AdvertisementResource($advertisement)
        ], 201);
    }
    
    public function update(StoreAdvertisementRequest $request, Advertisement $advertisement)
    {
        $advertisement->update($request->validated());
        
        return response()->json([
            'success' => true,
            'data' => new AdvertisementResource($advertisement)
        ]);
    }
    
    public function destroy(Advertisement $advertisement)
    {
        $advertisement->delete();
        
        return response()->json(['success' => true, 'message' => 'Anuncio eliminado']);
    }
}
```

### 8.7 AdminFooterController
```php
// app/Http/Controllers/Admin/AdminFooterController.php

class AdminFooterController extends Controller
{
    public function index()
    {
        $items = FooterItem::orderBy('section')->orderBy('order')->get();
        
        return response()->json([
            'success' => true,
            'data' => $items
        ]);
    }
    
    public function store(StoreFooterItemRequest $request)
    {
        $item = FooterItem::create($request->validated());
        
        return response()->json([
            'success' => true,
            'data' => $item
        ], 201);
    }
    
    public function update(StoreFooterItemRequest $request, FooterItem $footerItem)
    {
        $footerItem->update($request->validated());
        
        return response()->json([
            'success' => true,
            'data' => $footerItem
        ]);
    }
    
    public function destroy(FooterItem $footerItem)
    {
        $footerItem->delete();
        
        return response()->json(['success' => true, 'message' => 'Item eliminado']);
    }
}
```

### 8.8 Rutas Admin
```php
// routes/api.php

Route::prefix('admin')->middleware(['auth:sanctum', 'admin'])->group(function () {
    
    Route::apiResource('articles', AdminArticleController::class);
    Route::post('articles/{article}/publish', [AdminArticleController::class, 'publish']);
    Route::post('articles/{article}/unpublish', [AdminArticleController::class, 'unpublish']);
    
    Route::apiResource('tags', AdminTagController::class);
    Route::apiResource('authors', AdminAuthorController::class);
    Route::apiResource('advertisements', AdminAdvertisementController::class);
    Route::apiResource('footer', AdminFooterController::class)->parameters(['footer' => 'footerItem']);
    
    Route::get('settings', [AdminSettingController::class, 'index']);
    Route::put('settings', [AdminSettingController::class, 'update']);
    Route::put('settings/batch', [AdminSettingController::class, 'updateMultiple']);
    
    Route::get('dashboard', [DashboardController::class, 'index']);
});
```

---

## Verificación
- [ ] AdminArticleController completo
- [ ] AdminTagController completo
- [ ] AdminAuthorController completo
- [ ] AdminSettingController completo
- [ ] AdminAdvertisementController completo
- [ ] AdminFooterController completo
- [ ] Todas las rutas funcionando
- [ ] Probar CRUD con Postman/Insomnia

---

## Siguiente Paso
Ver [09-seo-ads-integration.md](./09-seo-ads-integration.md) para SEO y configuración de publicidades.
