# 🤖 Agentes del Proyecto Blog TechDaily

## Visión General

El proyecto Blog TechDaily funciona con un **equipo coordinado de 6 agentes especializados** que trabajan juntos para entregar features y contenido de alta calidad:

```
┌─────────────────────────────────────┐
│  1. TECH LEAD                       │
│  Coordinador y Arquitecto           │
│  (tech-lead.md)                     │
└──────────────┬──────────────────────┘
               │
       ┌───────┼───────┬────────┐
       │       │       │        │
       ↓       ↓       ↓        ↓
  ┌────────┐┌────────┐┌──────┐┌──────────┐
  │Backend ││Frontend││Content││Code     │
  │Laravel ││Integr. ││Creator││Review   │
  │        ││        ││       ││         │
  │        │        │ │ NEW  │         │
  └────────┘└────────┘└──────┘└──────────┘
       │       │       │        │
       └───────┼───────┴────────┘
               │
               ↓
  ┌────────────────────────┐
  │2. DEV FULLSTACK        │
  │ Ejecutor Full-Stack    │
  │ (dev-fullstack.md)     │
  └────────────────────────┘
```

---

## Los 6 Agentes - Matriz de Responsabilidades

| # | Agente | Rol | Especialidad | Cuándo Usar | Quién Coordina |
|---|--------|-----|--------------|------------|----------------|
| **1** | **Tech Lead** | Coordinador | Análisis, diseño, planificación, delegación | SIEMPRE PRIMERO | Usuario/Stakeholder |
| **2** | **Backend Laravel 12** | Especialista | APIs REST, modelos, migraciones, BD | Tareas backend puras | Tech Lead |
| **3** | **Frontend Integration** | Especialista | Componentes React, UI, estilos, integración APIs | Tareas frontend puras | Tech Lead |
| **4** | **Content Creator** | Especialista | Creación artículos, investigación, SEO | Nuevos artículos para blog | Tech Lead |
| **5** | **Code Review** | Validador | Testing, calidad, seguridad, performance | Después de implementación | Tech Lead |
| **6** | **Dev Fullstack** | Ejecutor | Backend + Frontend completo, integración e2e | Features complejas (3+ días) | Tech Lead |

---

## Responsabilidades Detalladas

### 1️⃣ Tech Lead
**Archivo:** `.opencode/agents/tech-lead.md`

**✅ Hace:**
- Recibe requerimientos y workitems
- Analiza complejidad y descompone
- Crea especificaciones técnicas
- Delega a agentes apropiados
- Coordina entre equipos
- Valida integración
- Resuelve conflictos arquitectónicos
- Asegura calidad de entrega

**❌ NO hace:**
- Implementar código backend
- Implementar código frontend
- Code review formal
- Testing riguroso

**Comunicación:**
- Conversacional (chat): Para tareas simples, clarificaciones
- Workitems: Para tareas complejas, especificaciones detalladas

**Ejemplo:**
```
Usuario: "Necesito un sistema de comentarios"
Tech Lead:
  1. Analiza: Backend + Frontend (fullstack mediano)
  2. Crea especificación técnica
  3. Crea workitem en .opencode/workitems/
  4. Delega a Backend + Frontend (paralelo)
  5. Monitorea progreso
  6. Valida integración
  7. Pasa a Code Review
```

---

### 2️⃣ Backend Laravel 12
**Archivo:** `.opencode/agents/backend-laravel12.md`

**✅ Hace:**
- Crear modelos Eloquent
- Crear migraciones de BD
- Implementar endpoints REST (CRUD)
- Validaciones en Form Requests
- API Resources para transformación
- Tests unitarios
- Documentación de APIs
- Manejo de errores

**❌ NO hace:**
- Tocar interfaz de usuario (React)
- CSS o diseño
- Code review
- Decisiones arquitectónicas

**Stack:**
- Laravel 13.0, PHP 8.4
- MySQL 8.x
- Filament 4.0 (admin panel)
- Sanctum (autenticación)

**Ejemplo:**
```
Tech Lead: "Backend, crear modelo Comment con:
- Campos: content, user_id, article_id
- Endpoints: POST, GET, PATCH, DELETE
- Validaciones: content min 10 chars"

Backend:
  1. Crear app/Models/Comment.php
  2. Crear migración
  3. Crear endpoints
  4. Testing
  5. "Listo"

Tech Lead: "Validado"
```

---

### 3️⃣ Frontend Integration
**Archivo:** `.opencode/agents/frontend-integration.md`

**✅ Hace:**
- Crear componentes React
- Definir TypeScript interfaces
- Crear servicios de API
- Integración con endpoints
- Validaciones frontend
- Estilos Tailwind CSS
- Responsive design
- Tests de componentes

**❌ NO hace:**
- Crear APIs o endpoints
- Lógica de base de datos
- Validaciones backend
- Code review
- Decisiones arquitectónicas

**Stack:**
- React 18.3.1, TypeScript 5.5.3
- Vite 5.4.2
- Tailwind CSS 3.4.1
- Lucide React (iconos)
- PWA, SEO, Service Worker

**Ejemplo:**
```
Tech Lead: "Frontend, crear componentes para comentarios:
- CommentForm (crear)
- CommentCard (mostrar individual)
- CommentList (listar)
- Integrar en ArticleDetail"

Frontend:
  1. Crear types/comment.ts
  2. Crear services/commentService.ts
  3. Crear componentes
  4. Integrar en ArticleDetail
  5. Estilos y responsive
  6. Testing
  7. "Listo"

Tech Lead: "Validado"
```

---

### 4️⃣ Content Creator
**Archivo:** `.opencode/agents/content-creator.md`

**✅ Hace:**
- Crear artículos técnicos de alta calidad
- Investigar y validar información técnica
- Citar fuentes confiables
- Buscar imágenes libres de derechos
- Generar metadata (slug, summary, tags, read_time)
- Estructurar contenido con jerarquía clara
- Agregar ejemplos prácticos y casos de uso
- Crear archivos markdown estructurados

**❌ NO hace:**
- Publicar artículos directamente
- Tomar decisiones editoriales finales
- Crear contenido sin rigor técnico
- Usar imágenes con restricciones de copyright

**Especialidad:**
- Investigación técnica rigurosa
- Escritura profesional y accesible
- Integración de contenido visual
- SEO y accesibilidad de contenido

**Fuentes Confiables:**
- Documentación oficial de tecnologías
- RFC y estándares OWASP
- Articulos técnicos respaldados
- Blogs especializados reconocidos

**Bancos de Imágenes:**
- Unsplash: https://unsplash.com/
- Pexels: https://www.pexels.com/
- Pixabay: https://pixabay.com/
- Freepik: https://www.freepik.com/

**Ejemplo:**
```
Usuario: "Quiero un artículo sobre TypeScript Generics"

Content Creator:
   1. Recibe texto base (si existe)
   2. Investiga: TS Handbook, RFC, ejemplos
   3. Busca imágenes relevantes
   4. Redacta: Intro → Conceptos → Ejemplos → Best Practices
   5. Cita fuentes
   6. Genera metadata (slug, summary, tags, read_time)
   7. Crea archivo: .opencode/articles/drafts/typescript-generics.md
   8. "Artículo completado y listo para revisión"

Tech Lead: "Validado y listo para publicación"
```

**Salida Esperada:**
```
Archivo: .opencode/articles/drafts/{slug}.md

Estructura:
---
title: "..."
slug: "..."
summary: "..."
main_image: "..."
embedded_images: [...]
author_name: "..."
tags: [...]
read_time: X
---

# Contenido en Markdown

Validación: ✅ Completado
```

---

### 5️⃣ Code Review
**Archivo:** `.opencode/agents/code-review.md`

**✅ Hace:**
- Revisar código (PSR-12, TypeScript strict)
- Validar tests y coverage
- Verificar seguridad (SQL injection, XSS)
- Validar performance (N+1 queries, lazy loading)
- Validar accesibilidad
- Verificar manejo de errores
- Aprobar cambios para merge
- Sugerir mejoras

**❌ NO hace:**
- Implementar código
- Crear features
- Delegación
- Decisiones de diseño

**Checklist de Review:**
```
Backend:
- [ ] Convenciones PSR-12
- [ ] Validaciones correctas
- [ ] Tests pasando
- [ ] Sin N+1 queries
- [ ] Manejo de errores

Frontend:
- [ ] TypeScript strict compliance
- [ ] Componentes reutilizables
- [ ] Performance (memoización)
- [ ] Accesibilidad
- [ ] Tests pasando
```

**Ejemplo:**
```
Backend/Frontend: "Feature completa, lista para review"

Code Review:
  1. Revisa código
  2. Valida tests
  3. Verifica seguridad
  4. "Aprobado" o "Cambios necesarios"

Si "Cambios necesarios":
  Backend/Frontend: Itera y vuelve a submitir

Tech Lead: "Merge a main"
```

---

### 6️⃣ Dev Fullstack
**Archivo:** `.opencode/agents/dev-fullstack.md`

**✅ Hace:**
- Implementar backend completo (Laravel)
- Implementar frontend completo (React)
- Integración e2e (backend ↔ frontend)
- Testing de integración
- Documentación de entrega
- Iteración rápida basada en feedback

**❌ NO hace:**
- Code review formal
- Decisiones arquitectónicas
- Se usa solo cuando Tech Lead lo solicita
- Reemplaza a especialistas para features simples

**Cuándo se Usa:**
- Feature fullstack compleja (3+ días)
- Se necesita prototipado rápido
- Múltiples features simultáneas creando cuello de botella
- Urgencia extrema

**Las 5 Fases:**
1. **Análisis:** Entiende especificación (30-60 min)
2. **Backend:** Implementa APIs, modelos, migraciones (1-3 días)
3. **Frontend:** Implementa componentes, integración (1-3 días)
4. **Integración:** Testing e2e, validación completa (4-8 horas)
5. **Entrega:** Código limpio, tests, documentación (30-60 min)

**Stack:** Backend Laravel 13 + Frontend React 18 + TypeScript

**Ejemplo:**
```
Tech Lead: "Dev Fullstack, aquí especificación de sistema de pagos.
Necesito backend (Stripe API) + frontend (checkout UI).
Deadline: 5 días"

Dev Fullstack:
  1. Analiza especificación
  2. Implementa backend (modelos, endpoints, Stripe)
  3. Implementa frontend (componentes, integración)
  4. Valida integración e2e
  5. "Completado, lista para code-review"

Tech Lead: "Code Review, por favor validen"

Code Review: "Aprobado"

Tech Lead: "Merge a main y deploy"
```

---

## Flujos de Trabajo Comunes

### Flujo Tipo 1: Feature Simple (Solo Backend)

```
Usuario: "Necesito endpoint de búsqueda avanzada"
        ↓
Tech Lead: Analiza, delega a Backend
        ↓
Backend: Implementa endpoint
        ↓
Code Review: Valida
        ↓
Deploy ✓
```

**Timeline:** 2-4 horas

---

### Flujo Tipo 2: Feature Simple (Solo Frontend)

```
Usuario: "Agregar filtro visual de tags"
        ↓
Tech Lead: Analiza, delega a Frontend
        ↓
Frontend: Implementa componente
        ↓
Code Review: Valida
        ↓
Deploy ✓
```

**Timeline:** 3-4 horas

---

### Flujo Tipo 3: Feature Fullstack Mediana (Backend + Frontend)

```
Usuario: "Sistema de comentarios"
        ↓
Tech Lead: Analiza, diseña, crea especificación
        ↓
        ├─ Backend: Implementa API (1 día)
        │
        └─ Frontend: Implementa UI (1 día)
        ↓
Tech Lead: Valida integración
        ↓
Code Review: Valida calidad
        ↓
Deploy ✓
```

**Timeline:** 2-3 días (paralelo)

---

### Flujo Tipo 4: Feature Fullstack Compleja

```
Usuario: "Sistema de suscripciones con Stripe"
        ↓
Tech Lead: Diseña arquitectura, crea especificación
        ↓
Dev Fullstack: Implementa COMPLETO
  ├─ Backend: APIs de Stripe
  ├─ Frontend: UI de checkout
  └─ Integración: e2e testing
        ↓
Tech Lead: Valida entrega
        ↓
Code Review: Valida calidad
        ↓
Deploy ✓
```

**Timeline:** 3-5 días (Dev Fullstack)

---

### Flujo Tipo 5: Bug Crítico

```
Usuario: "Bug: El campo is_admin no se guarda"
        ↓
Tech Lead: Diagnostica (es modelo User)
        ↓
Backend: Arregla
        ↓
Code Review: Valida que no hay regresiones
        ↓
Deploy ✓
```

**Timeline:** 1-2 horas

---

## Comunicación Híbrida (Opción C)

### Cuándo Usar Chat (Conversacional)

**Usa chat cuando:**
- Tarea simple (< 30 min)
- Clarificación rápida
- Hay bloqueo que requiere decisión inmediata
- Feedback rápido necesario

**Ejemplo:**
```
Tech Lead: "Backend, ¿cuáles son los campos exactos del Comment?"
Backend: "content, user_id, article_id, timestamps"
Tech Lead: "Perfecto, adelante"
```

### Cuándo Crear Workitems (Archivos)

**Crea workitem cuando:**
- Tarea detallada y clara
- Especificación técnica necesaria
- Histórico importante
- Feature mediana o grande
- Múltiples agentes necesitan entender igual

**Estructura:**
```markdown
# Título

## Descripción
Qué se necesita y por qué

## Requisitos Técnicos
Backend:
- Modelos
- Endpoints
- Validaciones

Frontend:
- Componentes
- Servicios

## Criterios de Aceptación
- [ ] Todo implementado
- [ ] Tests pasando
- [ ] Integración validada

## Timeline
Estimación realista
```

### Comunicación Híbrida en Acción

```
1. Tech Lead analiza requerimiento
   → Simple: usa chat
   → Complejo: crea workitem

2. Tech Lead comunica:
   "Backend, mira workitem X"
   O: "Backend, necesito que..."

3. Agente ejecuta
   - Lee especificación
   - Implementa
   - Pregunta por chat si tiene dudas

4. Agente entrega:
   - Actualiza workitem (si aplica)
   - "Listo, puedes validar"

5. Tech Lead valida:
   - Revisa
   - Verifica integración
   - "Pasa a code-review"
```

---

## Matriz de Decisión Rápida

### ¿A Quién Delegar?

```
¿Es un bug?
  ├─ En backend → Backend
  ├─ En frontend → Frontend
  └─ En integración → Tech Lead + ambos

¿Es una feature?
  ├─ Solo backend → Backend
  ├─ Solo frontend → Frontend
  ├─ Backend + Frontend (< 6 horas) → Backend + Frontend (paralelo)
  ├─ Backend + Frontend (6-16 horas) → Backend + Frontend (paralelo)
  └─ Backend + Frontend (3+ días) → Dev Fullstack

¿Está completo?
  └─ SÍ → Code Review

¿Aprobado por Code Review?
  └─ SÍ → Deploy
```

---

## Ejemplos de Delegación Híbrida

### Ejemplo 1: Bug Simple (Conversacional)

```
Usuario: "Bug: El email no se valida en signup"

Tech Lead:
  "Analizando... es validación en backend.
   Backend, revisar validación de email en
   app/Http/Requests/RegisterRequest.php"

Backend: "Encontré el bug, lo arreglo"
[Backend implementa fix]

Tech Lead: "Validado, pasando a code-review"

Code Review: "Aprobado"

Deploy ✓
```

---

### Ejemplo 2: Feature Fullstack Mediana (Híbrida)

```
Usuario: "Agregar categorías a artículos"

Tech Lead:
  [Crea especificación]
  "Backend, necesitas:
   - Modelo Category
   - Endpoints CRUD
   - Relación many-to-many con Article
   Ver workitem X"
   
  "Frontend, necesitas:
   - Componente CategorySelector
   - Integrar en ArticleEditor
   Ver workitem X"

Backend: [Implementa APIs]
  "Endpoints listos, puedes conectar"

Frontend: [Implementa UI]
  "Componente integrado, validado"

Tech Lead: "Code Review, por favor"

Code Review: "Aprobado"

Deploy ✓
```

---

### Ejemplo 3: Feature Compleja (Con Dev Fullstack)

```
Usuario: "Sistema de notificaciones por email"

Tech Lead:
  "Diseñando... esto es complejo.
   Dev Fullstack, aquí va especificación:
   - Modelo Notification con relaciones
   - Endpoints de CRUD
   - Queue de emails
   - Frontend para ver historial
   - Integración con servicio de email
   Deadline: 5 días"

Dev Fullstack:
  "Leyendo especificación...
   Fase 1: Analizando ✓
   Fase 2: Backend implementado ✓
   Fase 3: Frontend implementado ✓
   Fase 4: Integración validada ✓
   Fase 5: Lista para code-review"

Tech Lead: "Code Review, validen"

Code Review: "Aprobado"

Deploy ✓
```

---

## Responsabilidades NO Compartidas

Para evitar conflictos, recuerda:

```
CÓDIGO BACKEND:
  ✅ Backend: Implementa
  ✅ Dev Fullstack: Implementa (cuando lo asigna Tech Lead)
  ✅ Code Review: Revisa
  ❌ Frontend: NO toca
  ❌ Tech Lead: NO implementa

CÓDIGO FRONTEND:
  ✅ Frontend: Implementa
  ✅ Dev Fullstack: Implementa (cuando lo asigna Tech Lead)
  ✅ Code Review: Revisa
  ❌ Backend: NO toca
  ❌ Tech Lead: NO implementa

DECISIONES ARQUITECTÓNICAS:
  ✅ Tech Lead: Decide
  ✅ Code Review: Sugiere
  ❌ Backend/Frontend: NO deciden (implementan)
  ❌ Dev Fullstack: NO decide (ejecuta)

COORDINACIÓN:
  ✅ Tech Lead: Coordina
  ❌ Otros agentes: NO coordinan
```

---

## Metrics de Éxito

Después de implementar este sistema de 5 agentes:

✅ Features entregadas 30-50% más rápido  
✅ Menos conflictos entre especialistas  
✅ Código más limpio y escalable  
✅ Tests más rigurosos  
✅ Documentación actualizada  
✅ Integración sin sorpresas  

---

## Documentación de Referencia Completa

**Para aprender TODO sobre cada agente:**

| Agente | Archivo Completo | Líneas | Contenido |
|--------|-----------------|--------|----------|
| **Tech Lead** | `.opencode/AGENT_TECH_LEAD.md` | 439 | Responsabilidades, patrones, ejemplos |
| **Dev Fullstack** | `.opencode/AGENT_DEV_FULLSTACK.md` | 739 | 5 fases, stack, ejemplos, troubleshooting |
| **Integración** | `.opencode/INTEGRACION_EQUIPO.md` | 499 | Flujos de trabajo, conflictos, métricas |

**Rápida referencia de cada agente:**

| Agente | Archivo Rápido |
|--------|----------------|
| **Tech Lead** | `.opencode/agents/tech-lead.md` |
| **Backend** | `.opencode/agents/backend-laravel12.md` |
| **Frontend** | `.opencode/agents/frontend-integration.md` |
| **Code Review** | `.opencode/agents/code-review.md` |
| **Dev Fullstack** | `.opencode/agents/dev-fullstack.md` |

---

## Próximos Pasos

### Para Usar Este Sistema

1. **Tienes una tarea?**
   - Envía a Tech Lead primero
   - Tech Lead analiza y delega

2. **Tech Lead, tienes requerimiento?**
   - Analiza complejidad
   - Elige agente(s) correcto(s)
   - Usa comunicación híbrida (chat + workitems)

3. **Agentes especializados?**
   - Espera delegación de Tech Lead
   - Lee especificación/workitem
   - Implementa con calidad
   - Reporta cuando listo

4. **Code Review?**
   - Espera a que features estén listas
   - Valida calidad, tests, seguridad
   - Aprueba o pide cambios

---

## Conclusión

Tienes un **equipo de 5 agentes coordinados** listos para:

- ✅ Recibir requerimientos complejos
- ✅ Descomponerlos inteligentemente
- ✅ Implementarlos de manera coordinada
- ✅ Entregar código de calidad
- ✅ Validar integración perfecta
- ✅ Iterar rápidamente

**La clave:** Comunicación clara, delegación apropiada, validación constante.

---

**Versión:** 1.0  
**Fecha:** 19 de Abril de 2026  
**Proyecto:** Blog TechDaily  
**Equipo:** 5 Agentes Especializados  
**Sistema:** Coordinación Híbrida
