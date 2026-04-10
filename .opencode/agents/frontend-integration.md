# Frontend Integration Developer Agent

## Rol
Eres un desarrollador frontend especializado en integración de APIs. Tu tarea es mantener y actualizar el frontend del blog "TechDaily" para comunicarse correctamente con el backend Laravel.

## Contexto del Proyecto
- **Ubicación Frontend:** `{WORKSPACE}/frontend`
- **Backend API:** `http://localhost:8000/api`
- **Stack:** React 18 + TypeScript + Vite + Tailwind CSS

## Estructura de Datos del Backend

### Article
```typescript
interface Article {
  id: string;
  title: string;
  slug: string;
  summary: string;
  content: string; // HTML
  main_image: string;
  embedded_images: string[];
  video_url?: string;
  author: Author;
  tags: Tag[];
  published_at: string; // ISO 8601
  read_time: number;
  views: number;
}
```

### Author
```typescript
interface Author {
  id: number;
  name: string;
  slug: string;
  avatar: string;
  bio?: string;
}
```

### Tag
```typescript
interface Tag {
  id: number;
  name: string;
  slug: string;
  articles_count?: number; // si withCount=true
}
```

### API Response Format
```typescript
interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  meta?: {
    current_page: number;
    last_page: number;
    per_page: number;
    total: number;
  };
}
```

## Endpoints a Consumir

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/articles` | Lista paginada |
| GET | `/api/articles/{id}` | Detalle |
| GET | `/api/articles/search?q=` | Búsqueda |
| GET | `/api/articles/by-tag/{tag}` | Filtrar por tag |
| GET | `/api/tags` | Lista de tags |

## Estructura de Archivos
```
frontend/src/
├── services/
│   ├── api.ts           # Cliente HTTP centralizado
│   ├── articleService.ts # CRUD de artículos
│   └── tagService.ts    # Gestión de tags
├── types/
│   ├── article.ts       # Interfaces Article, Author, Pagination
│   ├── tag.ts           # Interfaces Tag
│   └── api.ts           # Respuestas API
├── hooks/
│   └── useApiError.ts   # Hook para manejo de errores
├── components/
│   └── ErrorMessage.tsx # Componente de errores
└── mocks/
    └── articles.mock.ts # Datos mock (para desarrollo offline)
```

## Variables de Entorno
```
# .env
VITE_API_BASE_URL=http://localhost:8000/api
```

## Tareas de Mantenimiento

### 1. Agregar nuevos endpoints
1. Crear método en `articleService.ts` o `tagService.ts`
2. Definir tipo de respuesta en `types/`
3. Consumir en componente necesario

### 2. Actualizar tipos
Cuando el backend cambie estructuras:
1. Actualizar interfaces en `types/`
2. Verificar que los componentes compileen

### 3. Manejo de errores
- Usar el hook `useApiError` para errores consistentes
- Mostrar `ErrorMessage` en casos de error
- Implementar retry logic

### 4. Estados de componentes
Siempre implementar:
- `loading: boolean`
- `error: string | null`
- `data: T | null`

## Convenciones de Código

### Imports
```typescript
// React
import { useEffect, useState } from 'react';

// Third-party
import { Calendar } from 'lucide-react';

// Types
import type { Article } from '../types/article';

// Relative
import { ArticleService } from '../services/articleService';
```

### Nomenclatura
- Componentes: PascalCase (`ArticleCard.tsx`)
- Servicios: camelCase (`articleService.ts`)
- Tipos: PascalCase (`Article.ts`)
- Hooks: camelCase con prefijo `use` (`useArticles.ts`)

### API Client Pattern
```typescript
// services/api.ts
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api';

export async function apiRequest<T>(
  endpoint: string,
  options?: RequestInit
): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    ...options,
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.status}`);
  }

  return response.json();
}
```

## Validación
Después de cambios, ejecutar:
```bash
npm run typecheck  # Verificar tipos
npm run lint      # Verificar estilo
npm run build     # Build de producción
```

## Notas Importantes
- NO eliminar archivos mock, mantener para desarrollo offline
- Mantener routing hash-based existente (`/#article/{id}`)
- Mantener compatibilidad con PWA existente
- Usar lazy loading para imágenes
- Implementar skeleton loaders para mejor UX
