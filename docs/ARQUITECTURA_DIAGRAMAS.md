# DIAGRAMA DE ARQUITECTURA - TECHDAILY BLOG

## ARQUITECTURA GENERAL

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            CLIENTE FINAL (USUARIO)                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
        ┌──────────────────────────────────────────────────────────────┐
        │           INTERNET / NAVEGADOR WEB                            │
        └──────────────────────────────────────────────────────────────┘
                    ↓                                    ↓
    ┌───────────────────────────────┐      ┌────────────────────────────┐
    │   FRONTEND (React SPA)         │      │  Caché del navegador       │
    │   http://localhost:5173        │      │  Service Worker            │
    │   https://chelistico.ar        │      │  LocalStorage              │
    └───────────────────────────────┘      └────────────────────────────┘
            │                                         │
            │ (HTTP API Calls)                       │ (Progressive Enhancement)
            │                                         │
            ↓                                         ↓
    ┌──────────────────────────────────────────────────────────────┐
    │   API REST BACKEND (Laravel 12)                              │
    │   http://blog-api.local/api                                  │
    │   https://api.chelistico.ar/api                              │
    └──────────────────────────────────────────────────────────────┘
            │
            │ (Eloquent Queries)
            │
            ↓
    ┌──────────────────────────────────────────────────────────────┐
    │   BASE DE DATOS (MySQL)                                      │
    │   docker_mysql:3306                                          │
    │   Usuario: root, Password: toor                              │
    │   BD: techdaily                                              │
    └──────────────────────────────────────────────────────────────┘
```

---

## ARQUITECTURA DE DESARROLLO LOCAL

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        COMPUTADORA DESARROLLO                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌────────────────────────┐           ┌────────────────────────┐       │
│  │  FRONTEND (Host)       │           │  BACKEND (Docker)      │       │
│  │                        │           │                        │       │
│  │  npm run dev           │           │  docker_php84          │       │
│  │  localhost:5173        │           │  Apache + PHP 8.4      │       │
│  │                        │           │                        │       │
│  │  ├─ src/              │           │  /var/www/html/blog/   │       │
│  │  ├─ public/           │           │  backend/              │       │
│  │  ├─ node_modules/     │           │  ├─ app/               │       │
│  │  └─ dist/ (build)     │           │  ├─ config/            │       │
│  │                        │           │  ├─ routes/            │       │
│  │  Vite Dev Server      │           │  └─ storage/           │       │
│  │  Hot Module Reload    │           │                        │       │
│  │                        │           │  blog-api.local        │       │
│  └────────────────────────┘           └────────────────────────┘       │
│         │                                      │                         │
│         │ HTTP Calls                          │ Eloquent                 │
│         │ http://blog-api.local/api           │ Queries                  │
│         │                                      │                         │
│         └──────────────────┬───────────────────┘                         │
│                            │                                             │
│                            ↓                                             │
│                  ┌──────────────────────┐                               │
│                  │   MySQL (Docker)     │                               │
│                  │   docker_mysql:3306  │                               │
│                  │                      │                               │
│                  │   techdaily          │                               │
│                  └──────────────────────┘                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## ESTRUCTURA DE CAPAS - FRONTEND

```
┌─────────────────────────────────────────────────────────────┐
│  PRESENTACIÓN (Componentes React)                           │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ App.tsx (Router)                                     │   │
│  │  ├─ Layout.tsx (Header + Footer)                    │   │
│  │  ├─ Home.tsx (Página principal)                     │   │
│  │  │  ├─ SearchBar                                    │   │
│  │  │  ├─ TagList                                      │   │
│  │  │  ├─ ArticleCard (x múltiples)                    │   │
│  │  │  └─ AdvertisementBanner                          │   │
│  │  └─ ArticleDetail.tsx (Detalle)                     │   │
│  │     ├─ OptimizedImage                               │   │
│  │     ├─ AdvertisementBanner                          │   │
│  │     └─ Related Articles                             │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  LÓGICA DE NEGOCIO (Services)                              │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ articleService.ts                                    │   │
│  │ ├─ fetchArticles()                                   │   │
│  │ ├─ fetchArticleById()                                │   │
│  │ ├─ searchArticles()                                  │   │
│  │ └─ fetchArticlesByTag()                              │   │
│  │                                                      │   │
│  │ tagService.ts                                        │   │
│  │ ├─ fetchAllTags()                                    │   │
│  │                                                      │   │
│  │ settingService.ts                                    │   │
│  │ ├─ getSettings()                                     │   │
│  │                                                      │   │
│  │ advertisementService.ts                              │   │
│  │ └─ getAdvertisements()                               │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  HTTP CLIENT (api.ts)                                       │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ ApiClient                                            │   │
│  │  ├─ get<T>(endpoint, params)                         │   │
│  │  ├─ post<T>(endpoint, body)                          │   │
│  │  ├─ Retry Logic (exponential backoff)                │   │
│  │  ├─ Timeout Handling                                 │   │
│  │  └─ Error Handling                                   │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  TIPOS (TypeScript Interfaces)                             │
│  ├─ Article, Author, Tag                                    │
│  ├─ Settings, Advertisement                                 │
│  └─ API Responses                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## ESTRUCTURA DE CAPAS - BACKEND

```
┌─────────────────────────────────────────────────────────────┐
│  ENTRADA (HTTP Requests)                                    │
│  ├─ GET /api/articles                                       │
│  ├─ GET /api/articles/{slug}                                │
│  ├─ POST /api/articles/search                               │
│  ├─ GET /api/tags                                           │
│  ├─ GET /api/advertisements                                 │
│  └─ ... (30+ endpoints)                                     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  ROUTING (routes/api.php)                                   │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Route::get('/articles', ArticleController@index)    │   │
│  │ Route::get('/articles/{id}', ArticleController@show)│   │
│  │ ... etc                                              │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  MIDDLEWARE                                                 │
│  ├─ CORS                                                    │
│  ├─ API Authentication (Sanctum)                            │
│  ├─ Admin Check                                             │
│  └─ Request Validation                                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  CONTROLADORES (Controllers/)                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ ArticleController                                    │   │
│  │  ├─ index()     → List articles                      │   │
│  │  ├─ show()      → Get article detail                 │   │
│  │  ├─ search()    → Search articles                    │   │
│  │  ├─ store()     → Create article                     │   │
│  │  └─ destroy()   → Delete article                     │   │
│  │                                                      │   │
│  │ TagController                                        │   │
│  │ AuthorController                                     │   │
│  │ AdvertisementController                              │   │
│  │ ... etc                                              │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  VALIDACIÓN (Form Requests)                                 │
│  ├─ ArticleRequest                                          │
│  ├─ Validación de campos                                    │
│  └─ Reglas de negocio                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  LÓGICA DE NEGOCIO (Modelos + Scopes)                       │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ Article Model                                        │   │
│  │  ├─ $fillable, $casts                                │   │
│  │  ├─ author() → BelongsTo Author                      │   │
│  │  ├─ tags() → BelongsToMany Tag                       │   │
│  │  ├─ published() → Scope                              │   │
│  │  ├─ incrementViews()                                 │   │
│  │                                                      │   │
│  │ Tag Model                                            │   │
│  │ Author Model                                         │   │
│  │ Advertisement Model                                  │   │
│  │ SiteSetting Model                                    │   │
│  │ ... etc                                              │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  TRANSFORMACIÓN (Resources)                                 │
│  ├─ ArticleResource                                         │
│  ├─ TagResource                                             │
│  ├─ Formateo de datos                                       │
│  └─ Relaciones incluidas                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  RESPUESTA JSON                                             │
│  ├─ {success: true, data: {...}, message: "..."}           │
│  ├─ {success: false, error: {...}}                         │
│  └─ Status codes: 200, 201, 404, 401, 422, etc.            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  BASE DE DATOS (MySQL via Eloquent)                         │
│  ├─ users table                                             │
│  ├─ articles table                                          │
│  ├─ tags table                                              │
│  ├─ article_tag junction table                              │
│  ├─ authors table                                           │
│  ├─ advertisements table                                    │
│  ├─ site_settings table                                     │
│  ├─ footer_items table                                      │
│  └─ ... más tablas                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## FLUJO COMPLETO DE UNA SOLICITUD

### Caso: Ver lista de artículos

```
1. USUARIO ABRE NAVEGADOR
   ↓
2. localhost:5173 (Frontend)
   ↓
3. React monta App.tsx → Home.tsx
   ↓
4. useEffect → ArticleService.fetchArticles()
   ↓
5. apiClient.get('/articles', {limit: 12})
   ↓
6. fetch('http://blog-api.local/api/articles?limit=12')
   ↓
7. BACKEND: Recibe GET /api/articles?limit=12
   ↓
8. Router → ArticleController@index()
   ↓
9. Article::with(['author', 'tags'])
         ->published()
         ->paginate(12)
   ↓
10. SQL Query a MySQL
    SELECT * FROM articles
    JOIN authors ON ...
    JOIN tags ON ...
    WHERE is_published = true AND published_at <= NOW()
    LIMIT 12
   ↓
11. Eloquent Collection de Articles
    ↓
12. ArticleResource::collection() transforma cada modelo
    ↓
13. JSON Response:
    {
      "success": true,
      "data": {
        "data": [
          {
            "id": 1,
            "title": "...",
            "slug": "...",
            "author": {...},
            "tags": [...]
          },
          ...
        ],
        "pagination": {
          "current_page": 1,
          "last_page": 5,
          "per_page": 12,
          "total": 60
        }
      }
    }
    ↓
14. Frontend recibe response
    ↓
15. Home.tsx → setArticles(response.data.data)
    ↓
16. Render: ArticleCard x múltiples en grid
    ↓
17. Usuario ve lista de artículos
```

---

## DIAGRAMA DE DATOS (ERD)

```
┌─────────────────┐
│     USERS       │
├─────────────────┤
│ id (PK)         │
│ name            │
│ email (UNIQUE)  │
│ password        │
│ role            │
│ is_admin        │
│ created_at      │
└────────┬────────┘
         │ 1:M
         │
         ↓
┌─────────────────────────────┐
│       ARTICLES              │
├─────────────────────────────┤
│ id (PK)                     │
│ title                       │
│ slug (UNIQUE)               │
│ summary                     │
│ content                     │
│ main_image                  │
│ embedded_images (JSON)      │
│ video_url                   │
│ author_id (FK)              │
│ published_at                │
│ is_published                │
│ read_time                   │
│ views                       │
│ created_at                  │
└────────┬─────────┬──────────┘
         │ 1       │ M:N
         │         │
         │         ↓
         │    ┌──────────────┐
         │    │ ARTICLE_TAG  │
         │    ├──────────────┤
         │    │ article_id   │
         │    │ tag_id       │
         │    └──────────────┘
         │         │
         │         ↓
         │    ┌──────────────┐
         │    │     TAGS     │
         │    ├──────────────┤
         │    │ id (PK)      │
         │    │ name         │
         │    │ slug         │
         │    │ description  │
         │    └──────────────┘
         │
         ↓
┌──────────────────┐
│     AUTHORS      │
├──────────────────┤
│ id (PK)          │
│ name             │
│ slug             │
│ avatar           │
│ bio              │
│ email            │
│ social_links(J)  │
│ is_active        │
└──────────────────┘


┌────────────────────────┐
│  ADVERTISEMENTS        │
├────────────────────────┤
│ id (PK)                │
│ name                   │
│ position               │
│ image                  │
│ link                   │
│ code                   │
│ dimensions             │
│ is_active              │
│ start_date             │
│ end_date               │
│ order                  │
└────────────────────────┘


┌────────────────────────┐
│   SITE_SETTINGS        │
├────────────────────────┤
│ id (PK)                │
│ key (UNIQUE)           │
│ value                  │
│ type                   │
│ group                  │
│ description            │
└────────────────────────┘


┌────────────────────────┐
│   FOOTER_ITEMS         │
├────────────────────────┤
│ id (PK)                │
│ title                  │
│ url                    │
│ category               │
│ order                  │
│ is_visible             │
└────────────────────────┘
```

---

## MAPA DE RUTAS API

```
┌─────────────────────────────────────────────────────────────┐
│                    API ENDPOINTS (/api)                      │
├─────────────────────────────────────────────────────────────┤
│
│  PÚBLICOS (Sin autenticación)
│  ────────────────────────────
│  GET     /articles                  → ArticleController@index
│  GET     /articles/{id}             → ArticleController@show
│  GET     /articles/search           → ArticleController@search
│  GET     /articles/by-tag/{tag}     → ArticleController@byTag
│  POST    /articles                  → ArticleController@store
│  PUT     /articles/{id}             → ArticleController@update
│  DELETE  /articles/{id}             → ArticleController@destroy
│
│  GET     /tags                      → TagController@index
│  GET     /tags/{id}                 → TagController@show
│
│  GET     /authors                   → AuthorController@index
│  GET     /authors/{id}              → AuthorController@show
│  GET     /authors/{id}/articles     → AuthorController@articles
│
│  GET     /settings                  → SettingController@index
│  GET     /advertisements            → AdvertisementController@index
│  GET     /footer                    → FooterController@index
│
│  GET     /home                      → HomeController@index
│  GET     /seo/article/{id}          → SeoController@article
│  GET     /seo/website               → SeoController@website
│
│  AUTH (Con token Sanctum)
│  ───────────────────────
│  POST    /auth/register             → AuthController@register
│  POST    /auth/login                → AuthController@login
│  POST    /auth/logout               → AuthController@logout (Auth)
│  GET     /auth/me                   → AuthController@me (Auth)
│
│  UPLOADS (Protegidos)
│  ───────────────────
│  POST    /upload/image              → UploadController@image (Auth)
│  DELETE  /upload/image              → UploadController@delete (Auth)
│
│  ADMIN (Requiere rol: admin)
│  ────────────────────────────
│  GET     /admin/articles            → AdminArticleController@index
│  POST    /admin/articles            → AdminArticleController@store
│  GET     /admin/articles/{id}       → AdminArticleController@show
│  PUT     /admin/articles/{id}       → AdminArticleController@update
│  DELETE  /admin/articles/{id}       → AdminArticleController@destroy
│  POST    /admin/articles/{id}/publish    → AdminArticleController@publish
│  POST    /admin/articles/{id}/unpublish → AdminArticleController@unpublish
│
│  GET     /admin/tags                → AdminTagController@index
│  POST    /admin/tags                → AdminTagController@store
│  ... (CRUD completo para cada recurso)
│
│  GET     /admin/settings            → AdminSettingController@index
│  PUT     /admin/settings            → AdminSettingController@update
│
└─────────────────────────────────────────────────────────────┘
```

