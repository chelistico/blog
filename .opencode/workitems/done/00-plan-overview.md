# Workitem: 00-Plan-Overview

## Proyecto: TechDaily Blog - Backend Laravel 12

### Descripción General
Este documento presenta la visión general del plan de implementación del backend Laravel 12 para el proyecto de blog TechDaily.

---

## Fases del Proyecto

| Fase | Nombre | Prioridad |
|------|--------|-----------|
| 01 | Configuración Inicial | Alta |
| 02 | Modelos y Migraciones | Alta |
| 03 | Controladores API | Alta |
| 04 | Recursos/Transformers | Alta |
| 05 | Rutas API | Alta |
| 06 | Gestión de Medios | Alta |
| 07 | Sistema de Autenticación | Alta |
| 08 | Gestión de Contenido | Media |
| 09 | Publicidades y SEO | Media |
| 10 | Testing | Baja |

---

## Entidades Principales

### 1. Articles (Posts)
- id, title, slug, summary, content, main_image
- embedded_images (JSON), video_url, published_at
- read_time, views, is_published
- author_id, created_at, updated_at

### 2. Authors
- id, name, slug, avatar, bio, email
- social_links (JSON), is_active
- created_at, updated_at

### 3. Tags
- id, name, slug
- created_at, updated_at

### 4. Article_Tag (pivot)
- article_id, tag_id

### 5. SiteSettings (Configuración General)
- id, key (unique), value, type (text, image, json)
- group (branding, seo, social, etc.)

### 6. Advertisements
- id, name, position (top, sidebar, inline, bottom)
- image, link, code (custom HTML), dimensions
- is_active, start_date, end_date

### 7. Footer
- id, section, content, link_url, order
- created_at, updated_at

---

## API Endpoints Planificados

### Articles
- `GET /api/articles` - Listado con paginación
- `GET /api/articles/{id}` - Detalle
- `GET /api/articles/search` - Búsqueda
- `GET /api/articles/by-tag/{tag}` - Filtrar por tag
- `GET /api/articles/latest` - Últimos artículos
- `GET /api/articles/popular` - Artículos populares

### Tags
- `GET /api/tags` - Listado

### Authors
- `GET /api/authors` - Listado
- `GET /api/authors/{id}` - Detalle

### Site Settings
- `GET /api/settings` - Configuraciones públicas

### Advertisements
- `GET /api/advertisements` - Anuncios activos

### SEO
- Structured data JSON-LD
- Open Graph meta tags
- Twitter Card meta tags

---

## Dependencias Externas
- Intervention Image (manipulación de imágenes)
- Spatie Laravel Sluggable (slugs automáticos)
- Laravel Scout (búsqueda full-text)

---

## Siguiente Paso
Ver [01-initial-setup.md](./01-initial-setup.md) para la configuración inicial del proyecto.
