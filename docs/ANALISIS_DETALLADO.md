# ANÁLISIS DETALLADO - PROYECTO BLOG TECHDAILY

## RESUMEN EJECUTIVO

**TechDaily** es una aplicación de blog de tecnología moderna construida con una arquitectura de dos capas:
- **Frontend**: SPA (Single Page Application) con React, TypeScript y Vite
- **Backend**: API REST con Laravel 12 y Filament para administración

El proyecto está diseñado para ejecutarse en contenedores Docker y está optimizado como PWA (Progressive Web App).

---

## 1. ESTRUCTURA DE DIRECTORIOS PRINCIPALES

```
/home/chelistico/Projects/docker-php84/www/blog/
├── frontend/                           # Aplicación React (≈1120 líneas TSX)
│   ├── src/
│   │   ├── components/                 # Componentes React reutilizables
│   │   │   ├── AdvertisementBanner.tsx # Banners publicitarios dinámicos
│   │   │   ├── ArticleCard.tsx         # Tarjeta de artículo individual
│   │   │   ├── Layout.tsx              # Layout principal (header + footer)
│   │   │   ├── SearchBar.tsx           # Buscador con debounce
│   │   │   ├── TagList.tsx             # Lista de tags filtrable
│   │   │   ├── OptimizedImage.tsx      # Componente de imagen optimizada
│   │   │   └── ErrorMessage.tsx        # Componente de error reutilizable
│   │   ├── pages/                      # Páginas de la aplicación
│   │   │   ├── Home.tsx                # Página principal (lista de artículos)
│   │   │   └── ArticleDetail.tsx       # Página de detalle de artículo
│   │   ├── services/                   # Capa de abstracción para APIs
│   │   │   ├── api.ts                  # Cliente HTTP con retry y timeout
│   │   │   ├── articleService.ts       # Métodos para artículos
│   │   │   ├── tagService.ts           # Métodos para tags
│   │   │   ├── settingService.ts       # Métodos para configuración del sitio
│   │   │   └── advertisementService.ts # Métodos para anuncios
│   │   ├── types/                      # Definiciones TypeScript
│   │   │   ├── article.ts              # Tipos para artículos, autor, tags
│   │   │   ├── tag.ts                  # Tipos para tags
│   │   │   ├── settings.ts             # Tipos para configuración del sitio
│   │   │   ├── advertisement.ts        # Tipos para anuncios
│   │   │   └── api.ts                  # Tipos genéricos de API
│   │   ├── utils/                      # Funciones utilitarias
│   │   │   ├── pwa.ts                  # Registro de Service Worker
│   │   │   ├── seo.ts                  # Actualización de meta tags
│   │   │   ├── analytics.ts            # Integración Google Analytics
│   │   │   └── imageUrl.ts             # Utilidades de URLs de imágenes
│   │   ├── mocks/                      # Datos mock para desarrollo/backup
│   │   │   └── articles.mock.ts
│   │   ├── App.tsx                     # Componente raíz (router)
│   │   ├── main.tsx                    # Entry point
│   │   └── index.css                   # Estilos globales Tailwind
│   ├── public/                         # Archivos estáticos
│   │   ├── service-worker.js           # Service Worker para PWA
│   │   ├── manifest.json               # Configuración PWA
│   │   └── offline.html                # Página offline
│   ├── dist/                           # Build de producción
│   ├── index.html                      # Template HTML
│   ├── vite.config.ts                  # Configuración Vite
│   ├── tailwind.config.js              # Configuración Tailwind CSS
│   ├── tsconfig.json                   # Configuración TypeScript
│   ├── postcss.config.js               # Configuración PostCSS
│   ├── eslint.config.js                # Configuración ESLint
│   ├── package.json                    # Dependencias NPM
│   ├── .env.example                    # Variables de entorno ejemplo
│   └── README.md                       # Documentación frontend
│
├── backend/                            # API Laravel 12
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   │   ├── Api/                # Controladores públicos API
│   │   │   │   │   ├── ArticleController.php
│   │   │   │   │   ├── TagController.php
│   │   │   │   │   ├── AuthorController.php
│   │   │   │   │   ├── AdvertisementController.php
│   │   │   │   │   ├── SettingController.php
│   │   │   │   │   ├── HomeController.php
│   │   │   │   │   ├── SeoController.php
│   │   │   │   │   ├── UploadController.php
│   │   │   │   │   ├── AuthController.php
│   │   │   │   │   └── FooterController.php
│   │   │   │   └── Admin/              # Controladores CRUD admin
│   │   │   │       ├── AdminArticleController.php
│   │   │   │       ├── AdminTagController.php
│   │   │   │       ├── AdminAuthorController.php
│   │   │   │       ├── AdminAdvertisementController.php
│   │   │   │       ├── AdminSettingController.php
│   │   │   │       └── AdminFooterController.php
│   │   │   ├── Resources/              # API Resources (transformers)
│   │   │   │   ├── ArticleResource.php
│   │   │   │   ├── ArticleCollection.php
│   │   │   │   ├── TagResource.php
│   │   │   │   ├── AuthorResource.php
│   │   │   │   ├── AdvertisementResource.php
│   │   │   │   └── SiteSettingResource.php
│   │   │   ├── Requests/               # Form Request Validation
│   │   │   │   ├── ArticleRequest.php
│   │   │   │   ├── StoreArticleRequest.php
│   │   │   │   └── UpdateArticleRequest.php
│   │   │   └── Middleware/
│   │   │       └── EnsureUserIsAdmin.php
│   │   ├── Models/                     # Modelos Eloquent
│   │   │   ├── User.php                # Usuario (admin/editor/viewer)
│   │   │   ├── Article.php             # Artículo de blog
│   │   │   ├── Tag.php                 # Categorías/tags
│   │   │   ├── Author.php              # Autor de artículos
│   │   │   ├── Advertisement.php       # Anuncios/publicidades
│   │   │   ├── SiteSetting.php         # Configuración del sitio
│   │   │   └── FooterItem.php          # Elementos del footer
│   │   ├── Filament/                   # Panel admin Filament
│   │   │   └── Resources/
│   │   │       ├── Articles/
│   │   │       │   ├── ArticleResource.php
│   │   │       │   ├── Schemas/ArticleForm.php
│   │   │       │   ├── Tables/ArticlesTable.php
│   │   │       │   └── Pages/
│   │   │       ├── Tags/
│   │   │       ├── Users/
│   │   │       ├── SiteSettings/
│   │   │       ├── FooterItems/
│   │   │       └── Advertisements/
│   │   └── Providers/                  # Service providers
│   ├── config/                         # Configuración Laravel
│   │   ├── app.php
│   │   ├── database.php
│   │   ├── filesystems.php
│   │   ├── sanctum.php
│   │   └── ... (otros configs)
│   ├── database/
│   │   ├── migrations/                 # Migraciones de BD
│   │   │   ├── create_users_table.php
│   │   │   ├── create_articles_table.php
│   │   │   ├── create_tags_table.php
│   │   │   ├── create_article_tag_table.php
│   │   │   ├── create_authors_table.php
│   │   │   ├── create_advertisements_table.php
│   │   │   ├── create_site_settings_table.php
│   │   │   ├── create_footer_items_table.php
│   │   │   └── ... (más migraciones)
│   │   ├── factories/                  # Factories para testing
│   │   └── seeders/                    # Seeders de datos
│   ├── routes/
│   │   ├── api.php                     # Rutas API
│   │   └── web.php                     # Rutas web (mínimas)
│   ├── storage/
│   │   └── app/public/
│   │       ├── images/
│   │       │   ├── articles/           # Imágenes principales artículos
│   │       │   │   └── embedded/       # Imágenes embebidas
│   │       │   └── advertisements/     # Imágenes de publicidades
│   │       └── livewire-tmp/           # Temporal
│   ├── public/                         # Raíz documentación web
│   │   └── storage/                    # Symlink a storage/app/public
│   ├── vite.config.js                  # Configuración Vite
│   ├── composer.json                   # Dependencias PHP
│   ├── .env.example                    # Variables de entorno ejemplo
│   └── README.md                       # Documentación backend
│
├── .opencode/                          # Documentación de agentes IA
│   ├── workitems/
│   └── docs/
│
└── README.md                           # Documentación principal del proyecto
```

---

## 2. STACK TECNOLÓGICO

### FRONTEND
```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND STACK                            │
├─────────────────────────────────────────────────────────────┤
│ Lenguaje:        TypeScript 5.5.3                           │
│ Framework:       React 18.3.1                               │
│ Build Tool:      Vite 5.4.2                                 │
│ Styling:         Tailwind CSS 3.4.1                         │
│ Icons:           Lucide React 0.344.0                       │
│ Backend Client:  Supabase JS 2.57.4 (instalado, no usado)  │
│ Linting:         ESLint 9.9.1                               │
│ PWA:             Service Worker + Manifest                  │
└─────────────────────────────────────────────────────────────┘
```

### BACKEND
```
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND STACK                             │
├─────────────────────────────────────────────────────────────┤
│ Lenguaje:        PHP 8.4                                    │
│ Framework:       Laravel 13.0                               │
│ Admin Panel:     Filament 4.0                               │
│ API Auth:        Laravel Sanctum 4.0                        │
│ Repl:            Tinker 3.0                                 │
│ Testing:         PHPUnit 12.5.12, Mockery 1.6              │
│ Code Quality:    Laravel Pint 1.27                          │
│ Faker:           FakerPHP 1.23                              │
└─────────────────────────────────────────────────────────────┘
```

### INFRAESTRUCTURA
```
┌─────────────────────────────────────────────────────────────┐
│                   INFRAESTRUCTURA                            │
├─────────────────────────────────────────────────────────────┤
│ Contenedor 1:    Docker PHP 8.4 + Apache 2.4                │
│ Contenedor 2:    MySQL 8.x                                  │
│ Virtual Host:    blog-api.local (desarrollo)                │
│                  api.chelistico.ar (producción)             │
│ HTTPS:           SSL/TLS en producción                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. ARCHIVOS DE CONFIGURACIÓN IMPORTANTES

### 3.1 FRONTEND

**package.json**
```json
{
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "lucide-react": "^0.344.0",
    "@supabase/supabase-js": "^2.57.4"
  },
  "devDependencies": {
    "typescript": "^5.5.3",
    "vite": "^5.4.2",
    "@vitejs/plugin-react": "^4.3.1",
    "tailwindcss": "^3.4.1"
  },
  "scripts": {
    "dev": "vite",                    # Inicia servidor desarrollo (puerto 5173)
    "build": "vite build",             # Build para producción
    "typecheck": "tsc --noEmit",       # Verificar tipos TypeScript
    "preview": "vite preview",         # Preview del build
    "lint": "eslint ."                 # Linting
  }
}
```

**vite.config.ts**
- Puerto de desarrollo: 5173
- Host: localhost
- Plugin React habilitado
- Lucide-react excluido de optimización de deps

**tailwind.config.js**
- Content: `./index.html`, `./src/**/*.{js,ts,jsx,tsx}`
- Tema por defecto (sin customizaciones)

**.env.example**
```
VITE_API_BASE_URL=http://blog-api.local/api
```

### 3.2 BACKEND

**composer.json**
```json
{
  "require": {
    "php": "^8.3",
    "laravel/framework": "^13.0",
    "filament/filament": "^4.0",
    "laravel/sanctum": "^4.0",
    "laravel/tinker": "^3.0"
  },
  "scripts": {
    "setup": ["composer install", "php artisan key:generate", ...],
    "dev": ["php artisan serve", "php artisan queue:listen", ...]
  }
}
```

**.env.example** (Desarrollo)
```
APP_NAME=TechDaily
APP_ENV=local
APP_DEBUG=true
APP_URL=http://blog-api.local
APP_LOCALE=es

DB_CONNECTION=mysql
DB_HOST=docker_mysql
DB_PORT=3306
DB_DATABASE=techdaily
DB_USERNAME=root
DB_PASSWORD=toor

SANCTUM_STATEFUL_DOMAINS=localhost:5173,blog-api.local
CORS_ALLOWED_ORIGINS=http://localhost:5173,http://blog-api.local
```

**vite.config.js** (Backend)
- Laravel plugin para assets
- Tailwind CSS plugin
- Input: `resources/css/app.css`, `resources/js/app.js`

**config/app.php**
- `APP_LOCALE=es`
- `APP_FALLBACK_LOCALE=es`

**config/sanctum.php**
- Autenticación API sin stateless (usa cookies)
- CORS habilitado

---

## 4. ESTRUCTURA DEL BACKEND (LARAVEL)

### 4.1 MODELOS DE DATOS

#### User (Usuario)
```php
class User extends Authenticatable implements FilamentUser {
  - id: integer
  - name: string
  - email: string (único)
  - password: string (hasheada)
  - role: string (admin|editor|viewer)
  - is_admin: boolean
  - email_verified_at: datetime
  - remember_token: string
  
  Métodos:
  - isAdmin(): bool
  - isEditor(): bool
  - canAccessPanel(Panel $panel): bool
}
```

#### Article (Artículo)
```php
class Article extends Model {
  - id: integer
  - title: string
  - slug: string (generado automáticamente)
  - summary: string (resumen)
  - content: text (HTML enriquecido)
  - main_image: string (ruta a imagen)
  - embedded_images: json array (imágenes embebidas)
  - video_url: string|null (URL de video)
  - author_id: integer (FK)
  - published_at: datetime|null
  - read_time: integer (minutos)
  - views: integer (contador)
  - is_published: boolean
  - created_at, updated_at: datetime
  
  Relaciones:
  - author(): BelongsTo
  - tags(): BelongsToMany
  
  Scopes:
  - published(): solo artículos publicados
  - scheduled(): artículos programados
  - draft(): borradores
  
  Métodos:
  - incrementViews()
  - getRouteKeyName() -> 'slug'
}
```

#### Tag (Categoría)
```php
class Tag extends Model {
  - id: integer
  - name: string
  - slug: string (generado automáticamente)
  - description: text|null
  - created_at, updated_at: datetime
  
  Relaciones:
  - articles(): BelongsToMany
  
  Scopes:
  - withArticleCount()
}
```

#### Author (Autor)
```php
class Author extends Model {
  - id: integer
  - name: string
  - slug: string (generado automáticamente)
  - avatar: string (ruta a imagen)
  - bio: text|null
  - email: string
  - social_links: json (redes sociales)
  - is_active: boolean
  - created_at, updated_at: datetime
  
  Relaciones:
  - articles(): HasMany
  
  Scopes:
  - active(): solo autores activos
}
```

#### Advertisement (Publicidad)
```php
class Advertisement extends Model {
  - id: integer
  - name: string
  - position: string (top|bottom|sidebar)
  - image: string|null (ruta a imagen)
  - link: string|null (URL destino)
  - code: string|null (código HTML/JS)
  - dimensions: string (ej: "728x90")
  - is_active: boolean
  - start_date: datetime|null
  - end_date: datetime|null
  - order: integer (para ordenar)
  - created_at, updated_at: datetime
  
  Scopes:
  - active(): anuncios activos y dentro de fecha
  - byPosition(string)
  - ordered()
  
  Métodos:
  - toAdSenseArray()
}
```

#### SiteSetting (Configuración)
```php
class SiteSetting extends Model {
  - id: integer
  - key: string (ej: "site_name")
  - value: string (valor)
  - type: string (string|json|boolean|image)
  - group: string (branding|seo|social|ads)
  - description: string
  - created_at, updated_at: datetime
  
  Métodos estáticos:
  - getValue(string $key, $default)
  - getValueCasted(string $key, $default)
  
  Scopes:
  - byGroup(string $group)
}
```

#### FooterItem (Elemento Footer)
```php
class FooterItem extends Model {
  - id: integer
  - title: string
  - url: string|null
  - category: string (about|contact|legal)
  - order: integer
  - is_visible: boolean
  - created_at, updated_at: datetime
}
```

### 4.2 RELACIONES ENTRE MODELOS

```
┌──────────────────────────────────────────────────────────┐
│                    DIAGRAMA ERD                           │
├──────────────────────────────────────────────────────────┤
│
│  Users                  Articles         Tags
│  ┌────────┐          ┌───────────┐   ┌──────┐
│  │ id (PK)├──────────┤ author_id │───┤ id   │
│  │ name   │ 1:M      └─────┬─────┘   │ name │
│  │ email  │                │         │ slug │
│  │ role   │                │         └──────┘
│  └────────┘         ┌──────┴──────┐
│                     │  Articles   │
│                     ├─────────────┤
│                     │ id          │
│                     │ title       │    ┌──────────────┐
│                     │ slug        │────┤ article_tag  │
│                     │ content     │ M:N│ ┌──────────┐ │
│                     │ author_id   │    │ │article_id│ │
│                     │ main_image  │    │ │tag_id    │ │
│                     │ is_published│    │ └──────────┘ │
│                     │ published_at│    └──────────────┘
│                     │ views       │
│                     └─────────────┘

│  Authors           Advertisements    FooterItems
│  ┌─────────┐      ┌───────────────┐ ┌────────────┐
│  │ id      │      │ id            │ │ id         │
│  │ name    │      │ name          │ │ title      │
│  │ slug    │      │ position      │ │ url        │
│  │ avatar  │      │ image/code    │ │ category   │
│  │ bio     │      │ is_active     │ │ order      │
│  │ email   │      │ start_date    │ │ is_visible │
│  │ is_active      │ end_date      │ └────────────┘
│  └─────────┘      │ order         │
│                   └───────────────┘

│  SiteSettings
│  ┌────────────────┐
│  │ id             │
│  │ key (unique)   │
│  │ value          │
│  │ type           │
│  │ group          │
│  │ description    │
│  └────────────────┘
│
└──────────────────────────────────────────────────────────┘
```

### 4.3 RUTAS API

#### Públicas (sin autenticación)

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/home` | Datos completos homepage |
| GET | `/api/articles` | Listado paginado de artículos |
| GET | `/api/articles/{id}` | Detalle de artículo (por ID o slug) |
| GET | `/api/articles/search?q=query` | Buscar artículos |
| GET | `/api/articles/by-tag/{tag}` | Artículos por tag |
| GET | `/api/articles/latest` | Últimos artículos |
| GET | `/api/articles/popular` | Artículos populares (más vistas) |
| GET | `/api/tags` | Listado de tags |
| GET | `/api/tags/{tag}` | Detalle de tag |
| GET | `/api/authors` | Listado de autores |
| GET | `/api/authors/{author}` | Detalle de autor |
| GET | `/api/authors/{author}/articles` | Artículos de autor |
| GET | `/api/settings` | Configuraciones del sitio |
| GET | `/api/advertisements` | Anuncios activos |
| GET | `/api/footer` | Items del footer |
| GET | `/api/seo/article/{id}` | JSON-LD de artículo |
| GET | `/api/seo/website` | JSON-LD del sitio |
| POST | `/api/auth/register` | Registro de usuario |
| POST | `/api/auth/login` | Login |

#### Autenticadas (Sanctum Token)
| Método | Ruta | Descripción |
|--------|------|-------------|
| POST | `/api/auth/logout` | Logout |
| GET | `/api/auth/me` | Usuario actual |
| POST | `/api/upload/image` | Subir imagen |
| DELETE | `/api/upload/image` | Eliminar imagen |

#### Admin (requiere rol `admin`)
| Método | Ruta | Descripción |
|--------|------|-------------|
| CRUD | `/api/admin/articles` | CRUD artículos |
| POST | `/api/admin/articles/{id}/publish` | Publicar |
| POST | `/api/admin/articles/{id}/unpublish` | Despublicar |
| CRUD | `/api/admin/tags` | CRUD tags |
| CRUD | `/api/admin/authors` | CRUD autores |
| CRUD | `/api/admin/advertisements` | CRUD anuncios |
| CRUD | `/api/admin/footer` | CRUD footer |
| GET/PUT | `/api/admin/settings` | Ver/actualizar configuración |

### 4.4 CONTROLADORES API

**ArticleController**
- `index()`: Lista paginada con filtros (tag, search)
- `show()`: Detalle por ID o slug, incrementa vistas
- `search()`: Búsqueda en título, resumen, contenido
- `byTag()`: Filtrar por tag
- `store()`: Crear artículo (validado)
- `update()`: Actualizar artículo
- `destroy()`: Eliminar artículo

**TagController**
- `index()`: Listado de tags
- `show()`: Detalle de tag

**AuthController**
- `register()`: Registro con validación
- `login()`: Login con email/password
- `logout()`: Destruir sesión
- `me()`: Obtener usuario actual

**SettingController**
- `index()`: Obtener todas las configuraciones agrupadas

**AdvertisementController**
- `index()`: Anuncios activos por posición

**UploadController**
- `image()`: Subir imagen a storage
- `delete()`: Eliminar imagen

**HomeController**
- `index()`: Datos agregados para homepage

**SeoController**
- `article()`: Schema.org para artículo
- `website()`: Schema.org para sitio

### 4.5 Resources (Transformadores)

**ArticleResource**: Transforma modelo Article a JSON
- Incluye relaciones: autor, tags
- Formatea fechas
- URLs relativas a absolutos

**ArticleCollection**: Colección paginada de artículos

**TagResource**: Transforma Tag a JSON

**AuthorResource**: Transforma Author a JSON

---

## 5. ESTRUCTURA DEL FRONTEND (REACT)

### 5.1 ARQUITECTURA DE COMPONENTES

#### Componentes Principales

**App.tsx** (Componente raíz)
```typescript
- State: routeState { route: 'home'|'article', articleId? }
- Efecto: Registra SW, carga settings, maneja hash navigation
- Render: <Layout><Home|ArticleDetail></Layout>
```

**Layout.tsx** (Layout principal)
```typescript
- State: mobileMenuOpen, settings
- Props: children (ReactNode)
- Estructura:
  - Banner publicitario superior
  - Header sticky con logo y navegación
  - Menu móvil responsive
  - Main content
  - Footer con información del sitio
```

**Home.tsx** (Página principal)
```typescript
- State: 
  - articles: Article[]
  - loading: boolean
  - searchQuery: string
  - selectedTag?: string
  - allTags: Tag[]
  - error?: string
- Acciones:
  - loadArticles()
  - loadTags()
  - handleSearch(query)
  - handleTagClick(tagSlug)
- Secciones:
  - Hero banner
  - SearchBar
  - AdvertisementBanner
  - TagList
  - Grid de ArticleCard
```

**ArticleDetail.tsx** (Detalle de artículo)
```typescript
- Props: articleId: string
- State:
  - article?: Article
  - loading: boolean
  - error?: string
  - relatedArticles: Article[]
- Contenido:
  - Título, autor, fecha, tiempo lectura
  - Imagen principal
  - Contenido HTML
  - Tags
  - Artículos relacionados
  - Anuncios intercalados
```

#### Componentes Reutilizables

**ArticleCard.tsx**
```typescript
- Props:
  - article: Article
  - onTagClick(slug: string): void
- Render:
  - Imagen miniatura
  - Título
  - Resumen
  - Meta (fecha, autor, tiempo lectura)
  - Tags como botones
```

**SearchBar.tsx**
```typescript
- Props:
  - onSearch(query: string): void
- State:
  - searchInput: string
- Features:
  - Debounce 300ms
  - Búsqueda en tiempo real
```

**TagList.tsx**
```typescript
- Props:
  - tags: string[]
  - tagSlugs: string[]
  - selectedTag?: string
  - onTagClick(slug: string): void
- Render: Chips/botones de tags
```

**AdvertisementBanner.tsx**
```typescript
- Props:
  - position: 'top'|'bottom'|'sidebar'
- State:
  - advertisements: Advertisement[]
- Features:
  - Soporte para código HTML/JS (adsense)
  - Fallback a imagen con link
  - Rotación de anuncios
```

**Layout.tsx** (ya mencionado arriba)

**OptimizedImage.tsx**
```typescript
- Props:
  - src: string
  - alt: string
  - className?: string
- Features:
  - Lazy loading
  - Manejo de errores
  - Fallback placeholder
```

**ErrorMessage.tsx**
```typescript
- Props:
  - message: string
  - onRetry(): void
- Render: Mensaje de error con botón de reintentar
```

### 5.2 SERVICIOS (Capa de Abstracción API)

**api.ts** (Cliente HTTP base)
```typescript
class ApiClient {
  - baseUrl: string
  - TIMEOUT: 10000ms
  - MAX_RETRIES: 3
  
  Métodos privados:
  - buildUrl(endpoint, params): string
  - request<T>(endpoint, options, retries): Promise<T>
    * Timeout automático
    * Retry exponencial backoff
    * Gestión de errores
    * Limpieza de auth_token en 401
  
  Métodos públicos:
  - get<T>(endpoint, params?): Promise<T>
  - post<T>(endpoint, body?): Promise<T>
}

class ApiError extends Error {
  - message: string
  - status: number
}

export const apiClient: ApiClient
```

**articleService.ts**
```typescript
class ArticleService {
  - fetchArticles(params?): Promise<ArticlesResult>
    * page, limit, tag
  - fetchArticleById(id): Promise<Article|null>
  - searchArticles(query, params?): Promise<ArticlesResult>
  - fetchArticlesByTag(tag, params?): Promise<ArticlesResult>
}
```

**tagService.ts**
```typescript
class TagService {
  - fetchAllTags(): Promise<Tag[]>
}
```

**settingService.ts**
```typescript
class SettingService {
  - getSettings(): Promise<SiteSettings>
    * Cachea settings en localStorage
    * TTL: 1 hora
}
```

**advertisementService.ts**
```typescript
class AdvertisementService {
  - getAdvertisements(position?: string): Promise<Advertisement[]>
    * Cachea por 5 minutos
    * Soporta filtro por posición
}
```

### 5.3 TIPOS (TypeScript Interfaces)

**article.ts**
```typescript
interface Author {
  id: number
  name: string
  slug: string
  avatar: string
  bio?: string
}

interface ArticleTag {
  id: number
  name: string
  slug: string
}

interface Article {
  id: string
  title: string
  slug: string
  summary: string
  content: string
  main_image: string
  embedded_images: string[]
  video_url?: string
  author: Author
  tags: ArticleTag[]
  published_at: string
  read_time: number
  views: number
  created_at: string
  updated_at: string
}

interface PaginationMeta {
  current_page: number
  last_page: number
  per_page: number
  total: number
}

interface ArticlesResponse {
  success: boolean
  data: {
    data: Article[]
    pagination: PaginationMeta
  }
}
```

**tag.ts**
```typescript
interface Tag {
  id: number
  name: string
  slug: string
  articles_count?: number
}
```

**settings.ts**
```typescript
interface SiteSettings {
  // Branding
  site_name: string
  site_title: string
  site_tagline: string
  logo: string
  favicon: string
  
  // SEO
  seo_title: string
  seo_description: string
  seo_keywords: string
  og_image: string
  
  // Social
  social_twitter?: string
  social_facebook?: string
  social_linkedin?: string
  social_github?: string
  
  // Analytics
  analytics_google?: string
  
  // Ads
  ads_adsense_client?: string
}
```

**advertisement.ts**
```typescript
interface Advertisement {
  id: number
  name: string
  position: string
  image?: string
  link?: string
  code?: string
  dimensions: string
  is_active: boolean
}
```

### 5.4 UTILITARIOS

**pwa.ts**
```typescript
- registerServiceWorker()
  * Registra /service-worker.js
  * Maneja actualizaciones
  
- checkInstallPrompt()
  * Detecta si PWA es instalable
  * Muestra prompt de instalación
```

**seo.ts**
```typescript
- updateMetaTags(config: MetaConfig)
  * Actualiza:
    - title
    - description (og:description)
    - keywords
    - og:url
    - og:image (fallback)
    - twitter:card
```

**analytics.ts**
```typescript
- initGoogleAnalytics(trackingId)
  * Carga Google Analytics (gtag)
  * Registra pageviews automáticos
```

**imageUrl.ts**
```typescript
- getImageUrl(path): string
  * Convierte rutas relativas a URLs absolutas
  * Usa VITE_API_BASE_URL como base
```

---

## 6. PATRONES ARQUITECTÓNICOS

### 6.1 FRONTEND

#### Single Page Application (SPA)
- Routing por hash (#home, #article/slug)
- Sin recarga de página, cambios DOM
- Estado en React componentes

#### Componentes Funcionales + Hooks
- Hooks: `useState`, `useEffect`, `useCallback`
- Composición sobre herencia
- Props drilling para contexto simple

#### Capas de Abstracción
```
UI (React Components)
      ↓
Services (API Calls)
      ↓
API Client (HTTP)
      ↓
Fetch API
```

#### Types First (TypeScript)
- Interfaces para todas las estructuras de datos
- Strict mode habilitado
- Type guards en servicios

#### Progressive Enhancement
- PWA con Service Worker
- Funciona offline con cache
- Fallback a datos mock

### 6.2 BACKEND

#### API REST RESTful
- Resources: Articles, Tags, Authors, etc.
- HTTP Methods: GET, POST, PUT, DELETE
- Status codes correctos (200, 201, 404, 401)

#### MVC (Model-View-Controller)
- **Model**: Eloquent ORM (User, Article, Tag, etc.)
- **View**: API Resources (transformadores)
- **Controller**: Lógica de negocio en controllers

#### API Resources (Transformers)
- Transforman modelos a JSON
- Formateo centralizado de respuestas
- Relaciones includidas/excluidas

#### Middleware
- Autenticación: Sanctum
- Admin check: `EnsureUserIsAdmin`
- CORS: Configurado en config/cors.php

#### Service Layer Pattern
- Controllers delegan en servicios
- Reutilización de lógica
- Testing más fácil

#### Repository Pattern (implícito)
- Queries encapsuladas en Scopes
- Query builders reutilizables
- `published()`, `active()`, `byPosition()`, etc.

---

## 7. INTEGRACIÓN FRONTEND-BACKEND

### 7.1 FLUJOS DE DATOS

#### Cargar Artículos (Home)
```
Home.tsx [useEffect]
    ↓
ArticleService.fetchArticles()
    ↓
apiClient.get('/articles', {page, limit})
    ↓
fetch('http://blog-api.local/api/articles')
    ↓
ArticleController.index()
    ↓
Article::with(['author', 'tags'])
       ->published()
       ->paginate()
    ↓
ArticleResource::collection()
    ↓
Response JSON {success, data: {data: [], pagination}}
    ↓
Home.tsx [setArticles]
```

#### Buscar Artículos
```
SearchBar [handleChange]
    ↓
Home.handleSearch(query)
    ↓
ArticleService.searchArticles(query)
    ↓
GET /articles/search?q=query
    ↓
ArticleController.search()
    ↓
Article::published()->where LIKE (title|summary|content)
    ↓
Response JSON
    ↓
Home.tsx [setArticles]
```

#### Ver Detalle de Artículo
```
ArticleCard [onClick hash/#article/slug]
    ↓
App.tsx [handleHashChange]
    ↓
setRouteState({route: 'article', articleId: slug})
    ↓
ArticleDetail.tsx [useEffect]
    ↓
ArticleService.fetchArticleById(slug)
    ↓
GET /articles/slug-del-articulo
    ↓
ArticleController.show()
    ↓
Article::where('slug', slug)->first()
    ↓
article.incrementViews()
    ↓
Response ArticleResource
    ↓
ArticleDetail.tsx [setArticle]
```

#### Filtrar por Tag
```
TagList [onClick tagSlug]
    ↓
Home.handleTagClick(tagSlug)
    ↓
ArticleService.fetchArticlesByTag(tagSlug)
    ↓
GET /articles/by-tag/tagslug
    ↓
ArticleController.byTag()
    ↓
Article::published()->whereHas('tags', where slug)
    ↓
Response JSON
    ↓
Home.tsx [setArticles]
```

### 7.2 LLAMADAS API PRINCIPALES

| Componente | Servicio | Endpoint | Frecuencia |
|-----------|----------|----------|-----------|
| Home | ArticleService | GET /articles | On mount |
| Home | TagService | GET /tags | On mount |
| Home | AdvertisementService | GET /advertisements | On mount |
| Home | SettingService | GET /settings | On mount |
| SearchBar | ArticleService | GET /articles/search | On input (debounce) |
| TagList | ArticleService | GET /articles/by-tag/{tag} | On click |
| ArticleDetail | ArticleService | GET /articles/{slug} | On mount |
| Layout | SettingService | GET /settings | On mount |
| AdvertisementBanner | AdvertisementService | GET /advertisements | On mount |

### 7.3 AUTENTICACIÓN & AUTORIZACIÓN

**Frontend**
- No implementada en el sitio (es público)
- Auth preparada para futuras funcionalidades
- Token guardado en localStorage si se implementa

**Backend**
- Sanctum: API tokens stateless
- Roles: admin, editor, viewer
- Middleware: `auth:sanctum`, `admin`
- Admin panel: Solo accesible con rol admin

---

## 8. DEPENDENCIAS Y RELACIONES ENTRE MÓDULOS

### 8.1 FRONTEND

```
App.tsx (root)
├── Layout.tsx
│   ├── AdvertisementBanner.tsx
│   └── useEffect → settingService
├── Home.tsx
│   ├── ArticleService (fetchArticles, searchArticles, fetchArticlesByTag)
│   ├── TagService (fetchAllTags)
│   ├── SearchBar.tsx
│   ├── TagList.tsx
│   ├── ArticleCard.tsx (múltiples)
│   │   └── ArticleTag component
│   └── AdvertisementBanner.tsx
├── ArticleDetail.tsx
│   ├── ArticleService (fetchArticleById)
│   ├── AdvertisementBanner.tsx
│   ├── OptimizedImage.tsx (múltiples)
│   └── Related articles (recursivo)

Services:
├── api.ts (base HTTP client)
├── articleService.ts (usa api.ts)
├── tagService.ts (usa api.ts)
├── settingService.ts (usa api.ts)
├── advertisementService.ts (usa api.ts)
└── authService.ts (usa api.ts, no usado aún)

Utils:
├── pwa.ts (service-worker)
├── seo.ts (DOM meta tags)
├── analytics.ts (window.gtag)
└── imageUrl.ts (URL construction)

Types:
├── article.ts
├── tag.ts
├── settings.ts
├── advertisement.ts
└── api.ts
```

### 8.2 BACKEND

```
routes/api.php (definición de rutas)
├── Controllers/Api/
│   ├── ArticleController → Article, Tag models
│   ├── TagController → Tag model
│   ├── AuthorController → Author model
│   ├── AdvertisementController → Advertisement model
│   ├── SettingController → SiteSetting model
│   ├── HomeController → Article, Tag, Advertisement models
│   ├── SeoController → Article model
│   ├── UploadController → Storage
│   ├── AuthController → User model
│   └── FooterController → FooterItem model
│
├── Controllers/Admin/ (protegidos)
│   ├── AdminArticleController
│   ├── AdminTagController
│   ├── AdminAuthorController
│   ├── AdminAdvertisementController
│   ├── AdminSettingController
│   └── AdminFooterController
│
├── Resources/ (transformadores)
│   ├── ArticleResource → Article model
│   ├── ArticleCollection
│   ├── TagResource → Tag model
│   ├── AuthorResource → Author model
│   ├── AdvertisementResource → Advertisement model
│   └── SiteSettingResource → SiteSetting model
│
├── Requests/ (validadores)
│   ├── ArticleRequest → Article create/update
│   ├── StoreArticleRequest
│   └── UpdateArticleRequest
│
├── Models/
│   ├── User (belongsToMany: roles)
│   ├── Article
│   │   ├── belongsTo: Author
│   │   └── belongsToMany: Tag
│   ├── Tag
│   │   └── belongsToMany: Article
│   ├── Author
│   │   └── hasMany: Article
│   ├── Advertisement
│   ├── SiteSetting
│   └── FooterItem
│
├── Filament/ (admin panel)
│   └── Resources/
│       ├── ArticleResource
│       ├── TagResource
│       ├── AuthorResource
│       ├── AdvertisementResource
│       ├── SiteSettingResource
│       ├── FooterItemResource
│       └── UserResource
│
├── Middleware/
│   └── EnsureUserIsAdmin.php
│
└── Providers/
    ├── RouteServiceProvider
    ├── AuthServiceProvider
    └── FilamentServiceProvider
```

---

## 9. SCRIPTS DE DESARROLLO Y DESPLIEGUE

### 9.1 FRONTEND

**Desarrollo**
```bash
npm install                    # Instalar dependencias
npm run dev                    # Iniciar servidor Vite (puerto 5173)
npm run typecheck              # Verificar tipos TypeScript
npm run lint                   # Ejecutar ESLint
```

**Producción**
```bash
npm run build                  # Build optimizado (dist/)
npm run preview               # Preview local del build
```

### 9.2 BACKEND

**Dentro del contenedor**
```bash
# Instalación inicial
composer install
php artisan key:generate
php artisan migrate --seed

# Desarrollo
php artisan serve --host=0.0.0.0 --port=80
php artisan tinker            # REPL PHP
php artisan queue:listen      # Colas

# Testing
php artisan test
php artisan test --coverage

# Limpiar cachés
php artisan config:clear
php artisan cache:clear
php artisan route:clear

# Ver rutas
php artisan route:list
```

**Con Docker Compose**
```bash
# Migraciones
docker exec -w /var/www/html/blog/backend docker_php84 php artisan migrate

# Seeders
docker exec -w /var/www/html/blog/backend docker_php84 php artisan db:seed

# Comandos Artisan
docker exec docker_php84 bash -c "cd /var/www/html/blog/backend && php artisan <command>"

# Acceder a MySQL
docker exec -it docker_mysql mysql -uroot -ptoor techdaily
```

### 9.3 PRODUCCIÓN

**Frontend**
```bash
# Build
npm run build

# Deploy a servidor estático (Netlify, Vercel, S3, etc.)
# Servir desde dist/ o usar CI/CD
```

**Backend**
```bash
# En servidor
composer install --optimize-autoloader --no-dev
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Permisos
chown -R www-data:www-data storage bootstrap/cache
chmod -R 755 storage bootstrap/cache
chmod 775 storage/app/public/images/*

# SSL
# Configurar certificados en Apache VirtualHost
```

### 9.4 BASE DE DATOS

**Desarrollo (Docker)**
```bash
# Verificar conexión
docker exec docker_mysql mysql -uroot -ptoor -e "SHOW DATABASES;"

# Backups
docker exec docker_mysql mysqldump -uroot -ptoor techdaily > backup.sql

# Restore
docker exec -i docker_mysql mysql -uroot -ptoor techdaily < backup.sql
```

**Migraciones**
```bash
php artisan migrate                  # Ejecutar migraciones pendientes
php artisan migrate:fresh           # Reset y ejecutar todas
php artisan migrate:fresh --seed    # Reset y ejecutar seeders
php artisan migrate:status          # Ver estado de migraciones
php artisan migrate:rollback        # Revertir último batch
```

---

## 10. RESUMEN EJECUTIVO - KEY POINTS

| Aspecto | Detalle |
|--------|---------|
| **Tipo de Proyecto** | Blog de tecnología (SPA + API) |
| **Lenguajes** | TypeScript (frontend), PHP (backend) |
| **Frameworks** | React 18 + Vite, Laravel 13 + Filament 4 |
| **Base de Datos** | MySQL 8.x |
| **Autenticación** | Laravel Sanctum (tokens) |
| **Admin Panel** | Filament (CRUD visual) |
| **PWA** | Sí, instalable como app |
| **SEO** | Meta tags dinámicos + JSON-LD |
| **Estilos** | Tailwind CSS |
| **Deploy** | Docker (desarrollo), cloud (producción) |
| **CORS** | Habilitado entre localhost:5173 y blog-api.local |
| **Imágenes** | Storage local (producción: S3 recomendado) |
| **API Endpoints** | 30+ (públicos + protegidos + admin) |
| **Modelos BD** | 7 tablas principales |
| **Componentes React** | 7 componentes reutilizables |
| **Services** | 5 servicios de abstracción API |

---

## 11. CHECKLIST DE CARACTERÍSTICAS IMPLEMENTADAS

- [x] Listado de artículos con paginación
- [x] Búsqueda en tiempo real
- [x] Filtrado por tags/categorías
- [x] Vista detallada de artículos
- [x] Sistema de autores
- [x] Contador de vistas
- [x] Tiempo de lectura estimado
- [x] Imágenes principales y embebidas
- [x] Soporte para videos
- [x] Banners publicitarios dinámicos
- [x] Configuración del sitio (branding, SEO)
- [x] Footer dinámico
- [x] Responsivo (mobile-first)
- [x] PWA completa
- [x] SEO optimizado
- [x] Panel admin con Filament
- [x] API REST documentada
- [x] Autenticación con Sanctum
- [x] Carga de imágenes
- [x] Validación de datos
- [x] Manejo de errores
- [x] Cache de configuración

---

## 12. PRÓXIMAS MEJORAS SUGERIDAS

1. **Frontend**
   - Implementar paginación completa
   - Carrito de comentarios
   - Newsletters subscription
   - Dark mode toggle
   - Internacionalización (i18n)

2. **Backend**
   - Rate limiting
   - API versioning
   - Webhooks
   - Scheduled publishing mejorado
   - Media library mejorada
   - Estadísticas y analytics

3. **Infraestructura**
   - CDN para imágenes (S3, Cloudflare)
   - Redis para caching
   - Elasticsearch para búsqueda avanzada
   - CI/CD pipeline (GitHub Actions, GitLab CI)
   - Monitoring (Sentry, New Relic)

4. **Seguridad**
   - Rate limiting en APIs
   - WAF (Web Application Firewall)
   - DDoS protection
   - Auditing y logging mejorado

