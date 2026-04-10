# Workitem: 04-api-resources

## Fase 4: API Resources (Transformers)

### Objetivo
Crear los API Resources para formatear las respuestas de la API de manera consistente.

---

## Tasks

### 4.1 ArticleResource
```php
// app/Http/Resources/ArticleResource.php

class ArticleResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'summary' => $this->summary,
            'content' => $this->content,
            'main_image' => $this->main_image,
            'embedded_images' => $this->embedded_images ?? [],
            'video_url' => $this->video_url,
            'author' => new AuthorResource($this->whenLoaded('author')),
            'tags' => TagResource::collection($this->whenLoaded('tags')),
            'published_at' => $this->published_at?->toIso8601String(),
            'read_time' => $this->read_time,
            'views' => $this->views,
            'created_at' => $this->created_at->toIso8601String(),
            'updated_at' => $this->updated_at->toIso8601String(),
        ];
    }
}
```

### 4.2 ArticleCollection
```php
// app/Http/Resources/ArticleCollection.php

class ArticleCollection extends ResourceCollection
{
    public function toArray($request)
    {
        return [
            'success' => true,
            'data' => $this->collection,
            'pagination' => [
                'current_page' => $this->currentPage(),
                'last_page' => $this->lastPage(),
                'per_page' => $this->perPage(),
                'total' => $this->total(),
            ]
        ];
    }
}
```

### 4.3 AuthorResource
```php
// app/Http/Resources/AuthorResource.php

class AuthorResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'avatar' => $this->avatar,
            'bio' => $this->when($this->bio, $this->bio),
            'social_links' => $this->social_links ?? [],
        ];
    }
}
```

### 4.4 TagResource
```php
// app/Http/Resources/TagResource.php

class TagResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'articles_count' => $this->when(
                $this->articles_count !== null,
                $this->articles_count
            ),
        ];
    }
}
```

### 4.5 AdvertisementResource
```php
// app/Http/Resources/AdvertisementResource.php

class AdvertisementResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'position' => $this->position,
            'image' => $this->image,
            'link' => $this->link,
            'code' => $this->when($this->code, $this->code),
            'dimensions' => $this->dimensions,
        ];
    }
}
```

### 4.6 Configurar Resource en Controladores
Modificar ArticleController para usar ArticleCollection:

```php
// En ArticleController
use App\Http\Resources\ArticleCollection;

public function index(Request $request)
{
    // ...
    return new ArticleCollection($articles);
}

public function search(Request $request)
{
    // ...
    return new ArticleCollection($articles);
}

public function byTag(string $tag)
{
    // ...
    return new ArticleCollection($articles);
}
```

---

## Response Examples

### Article Response
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "El futuro de TypeScript",
    "slug": "el-futuro-de-typescript",
    "summary": "Exploramos las nuevas características...",
    "content": "<p>Contenido HTML...</p><pre><code>const x = 1;</code></pre>",
    "main_image": "/storage/images/article.jpg",
    "embedded_images": [],
    "video_url": null,
    "author": {
      "id": 1,
      "name": "María González",
      "slug": "maria-gonzalez",
      "avatar": "/storage/avatars/avatar.jpg",
      "bio": "Desarrolladora Full Stack"
    },
    "tags": [
      {"id": 1, "name": "TypeScript", "slug": "typescript"}
    ],
    "published_at": "2025-09-28T10:00:00+00:00",
    "read_time": 8,
    "views": 1523,
    "created_at": "2025-09-28T10:00:00+00:00",
    "updated_at": "2025-09-28T10:00:00+00:00"
  }
}
```

---

## Verificación
- [ ] ArticleResource creado
- [ ] ArticleCollection creado
- [ ] AuthorResource creado
- [ ] TagResource creado
- [ ] AdvertisementResource creado
- [ ] Controladores actualizados para usar recursos

---

## Siguiente Paso
Ver [05-api-routes.md](./05-api-routes.md) para definir las rutas API.
