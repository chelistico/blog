# Backend Developer Agent - Laravel 12

## Rol
Eres un desarrollador backend especializado en Laravel 12. Tu tarea es crear y mantener la estructura del proyecto Laravel para el blog "TechDaily".

## Contexto del Proyecto
El proyecto es un blog de tecnología en español con las siguientes características:
- **Nombre:** TechDaily
- **Contenido:** Artículos de tecnología, programación y desarrollo
- **Idioma:** Español (es-ES)
- **Ubicación del proyecto:** `{WORKSPACE}/backend`

## Estructura de Datos Requerida

### Article (Artículos)
```
- id: bigint (auto increment, primary key)
- title: string (255)
- slug: string (255, unique)
- summary: text
- content: longText (HTML)
- main_image: string (255)
- embedded_images: json
- video_url: string (255, nullable)
- author_id: bigint (foreign key -> authors.id)
- published_at: timestamp (nullable)
- read_time: integer (minutes)
- views: integer (default 0)
- created_at: timestamp
- updated_at: timestamp
```

### Author (Autores)
```
- id: bigint (auto increment, primary key)
- name: string (255)
- slug: string (255, unique)
- avatar: string (255)
- bio: text (nullable)
- email: string (255, unique)
- created_at: timestamp
- updated_at: timestamp
```

### Tag (Etiquetas)
```
- id: bigint (auto increment, primary key)
- name: string (255)
- slug: string (255, unique)
- created_at: timestamp
- updated_at: timestamp
```

### Pivot: article_tag
```
- article_id: bigint (foreign key)
- tag_id: bigint (foreign key)
```

## Endpoints de API Requeridos

### GET /api/articles - Listar artículos
- **Query params:** `page`, `limit`, `tag`, `search`
- **Response:** articles + pagination
- **Orden:** Por `published_at` DESC

### GET /api/articles/{id} - Detalle de artículo
- Incrementa contador de vistas (+1)
- Incluye datos de autor y tags relacionados

### GET /api/articles/search - Búsqueda
- **Query params:** `q`, `page`, `limit`
- Busca en: title, summary, content

### GET /api/articles/by-tag/{tag} - Filtrar por tag
- **Query params:** `page`, `limit`
- Filtra por slug de tag

### GET /api/tags - Listar tags
- **Query params:** `withCount` (boolean) - incluye contador de artículos

## API Response Format
```json
{
  "success": true,
  "data": { ... },
  "message": "Operación exitosa"
}
```

Para paginación incluir en `meta`:
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 10,
    "total": 48
  }
}
```

## Estructura de Archivos
```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── ArticleController.php
│   │   │       └── TagController.php
│   │   ├── Requests/
│   │   │   └── ArticleRequest.php
│   │   └── Resources/
│   │       ├── ArticleResource.php
│   │       ├── ArticleCollection.php
│   │       ├── AuthorResource.php
│   │       └── TagResource.php
│   └── Models/
│       ├── Article.php
│       ├── Author.php
│       └── Tag.php
├── database/
│   ├── migrations/
│   └── seeders/
│       └── ArticleSeeder.php
├── routes/
│   └── api.php
└── .env.example
```

## Requisitos Técnicos

1. **Modelo Article.php**
   - Relaciones: belongsTo(Author), belongsToMany(Tag)
   - Scopes: published(), scopeSearch($query, $search)
   - Método: incrementViews()

2. **Modelo Author.php**
   - Relaciones: hasMany(Article)

3. **Modelo Tag.php**
   - Relaciones: belongsToMany(Article)

4. **Controllers**
   - Usar API Resources para formatear respuestas
   - Validación con FormRequest
   - Manejo de errorestry-catch

5. **Seeds**
   - 8 artículos de tecnología (datos mock existentes en frontend)
   - 4-6 autores
   - 10-15 tags

## Artículos Mock (para Seeder)
1. "El futuro de TypeScript: Novedades en la versión 5.5"
2. "Arquitectura de Microservicios: Patrones y mejores prácticas"
3. "React Server Components: El cambio de paradigma en React"
4. "PostgreSQL vs MongoDB: ¿Cuál elegir en 2025?"
5. "Seguridad en aplicaciones web: Vulnerabilidades comunes en 2025"
6. "Docker y Kubernetes: Containerización en producción"
7. "Inteligencia Artificial en desarrollo: GitHub Copilot y alternativas"
8. "Optimización de rendimiento en aplicaciones React"

## Comandos de Ejecución
```bash
# Migraciones
php artisan migrate

# Seeds
php artisan db:seed

# Servidor
php artisan serve --host=0.0.0.0 --port=8000
```

## Recomendaciones
- Usar SLUG para URLs amigables
- Sanitizar HTML del content antes de guardar
- Implementar rate limiting en rutas API
- Configurar CORS si es necesario
