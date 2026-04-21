# 🚀 Guía Rápida: Cómo Usar el Agente Content Creator

## 📌 Resumen Ejecutivo

El **Content Creator** es un agente especializado que transforma tu texto base en artículos técnicos profesionales, listos para publicar. Invierte en:

- ✅ Investigación técnica rigurosa
- ✅ Búsqueda de imágenes de calidad (libres de derechos)
- ✅ Estructura clara y profesional
- ✅ Citación de fuentes
- ✅ Ejemplos prácticos
- ✅ Metadata SEO (slug, tags, read_time)

**Salida:** Archivo Markdown en `.opencode/articles/drafts/{slug}.md`

---

## 💬 Cómo Solicitar un Artículo

### Formato Básico

```
Necesito crear un artículo sobre [TEMA]

[Opcional: texto base, ideas, notas]

[Opcional: requisitos especiales]
```

### Ejemplo Completo

```
Necesito crear un artículo sobre React Server Components

Texto base:
Los Server Components de React permiten renderizar componentes en el servidor
sin enviar JavaScript al cliente. Esto reduce significativamente el bundle size
y mejora el rendimiento...

Requisitos especiales:
- Nivel técnico: Intermedio
- Incluir: Comparativa con componentes tradicionales
- Enfoque: Práctico con ejemplos de Next.js
- Mínimo 2 imágenes de calidad
```

---

## 📊 Propiedades que Genera Automáticamente

El Content Creator genera y valida estas propiedades:

| Propiedad | Ejemplo | Descripción |
|-----------|---------|-------------|
| **title** | "React Server Components: Renderizado del Futuro" | Título principal (45-65 caracteres) |
| **slug** | "react-server-components-renderizado" | URL-safe, para navegación |
| **summary** | "Descubre cómo los RSC revolucionan..." | Resumen 150-200 caracteres |
| **content** | HTML/Markdown estructurado | Contenido completo del artículo |
| **main_image** | URL de imagen 1200x800 | Imagen de portada |
| **embedded_images** | [Array de URLs] | Imágenes dentro del contenido |
| **tags** | ["React", "Frontend", ...] | 3-5 tags relevantes |
| **read_time** | 10 | Minutos estimados (palabras/200) |
| **author_name** | "Especialista en Desarrollo" | Nombre del autor |

---

## 📁 Estructura de Archivo Generado

El Content Creator crea archivos en este formato:

```markdown
---
title: "..."
slug: "..."
summary: "..."
main_image: "..."
embedded_images: [...]
author_name: "..."
author_slug: "..."
tags: [...]
read_time: X
---

# Título Principal

## Sección 1
Contenido...

## Sección 2
Contenido...

## Referencias
- [Fuente](url)
```

**Ubicación:** `.opencode/articles/drafts/{slug}.md`

---

## 🔍 Características Principales

### 1. Investigación Técnica Rigurosa
- Valida información contra documentación oficial
- Cita fuentes confiables (RFC, estándares, blogs reconocidos)
- Mantiene actualidad de versiones y frameworks

### 2. Imágenes de Calidad
Busca en plataformas libres de derechos:
- **Unsplash**: https://unsplash.com/
- **Pexels**: https://www.pexels.com/
- **Pixabay**: https://pixabay.com/
- **Freepik**: https://www.freepik.com/

### 3. Estructura Profesional
```
Introducción (100-150 palabras)
    ↓
3-5 Secciones principales con h2
    ↓
Mínimo 2 ejemplos prácticos
    ↓
Conclusión (50-100 palabras)
    ↓
Referencias citadas
```

### 4. Ejemplos Prácticos
Cada concepto viene acompañado de:
- Código funcional
- Casos de uso reales
- Comparativas si aplica
- Best practices

---

## 📋 Estándares de Calidad

Antes de entregar, Content Creator valida:

- ✅ Título claro y descriptivo (45-65 caracteres)
- ✅ Slug URL-safe
- ✅ Resumen 150-200 caracteres
- ✅ Contenido 1200-2000 palabras (aprox)
- ✅ Mínimo 2 ejemplos prácticos
- ✅ Mínimo 2 fuentes citadas
- ✅ 1-3 imágenes de calidad
- ✅ 3-5 tags relevantes
- ✅ Tono profesional consistente
- ✅ Sin errores ortográficos
- ✅ Read time calculado correctamente
- ✅ Archivo markdown bien formateado

---

## 🎯 Tipos de Artículos que Crea Bien

### ✅ Excelente Con:
- Tutoriales técnicos (paso a paso)
- Guías de frameworks (React, Next.js, etc.)
- Explicaciones de conceptos (TypeScript, async/await)
- Comparativas tecnológicas
- Best practices y patrones
- Artículos DevOps e infraestructura
- Seguridad en aplicaciones web

### ⚠️ Requiere Validación Extra:
- Contenido muy especializado (requiere revisión experto)
- Artículos sobre múltiples tecnologías simultáneamente
- Tendencias muy nuevas (requiere research exhaustivo)

---

## 🔄 Flujo Típico

```
1. Tú escribes solicitud
        ↓
2. Content Creator recibe y analiza
        ↓
3. Investiga fuentes y busca imágenes
        ↓
4. Redacta artículo completo y profesional
        ↓
5. Genera metadata (slug, tags, read_time)
        ↓
6. Crea archivo markdown en drafts/
        ↓
7. Valida checklist de calidad
        ↓
8. Entrega y resume cambios realizados
```

**Tiempo estimado:** 20-45 minutos por artículo

---

## 💡 Tips para Mejores Resultados

### 1. Proporciona Contexto Claro
```
❌ Malo: "Escribe sobre APIs REST"
✅ Bueno: "Escribe sobre APIs REST en Node.js con Express, 
           enfoque en autenticación JWT y validación de datos"
```

### 2. Comparte tu Base (si la tienes)
```
El Content Creator partirá de tu idea y la completará con:
- Mejor estructura
- Más ejemplos
- Fuentes verificadas
- Imágenes relevantes
```

### 3. Especifica el Nivel Técnico
```
- Junior: Conceptos básicos, explicaciones detalladas
- Intermedio: Conceptos avanzados, mejores prácticas
- Senior: Patrones complejos, edge cases, alternativas
```

### 4. Menciona si Necesitas Video
```
"Incluir video de YouTube demostrando el concepto"
→ El Content Creator añadirá video_url al metadata
```

---

## 📞 Coordinación con Tech Lead

**Flujo recomendado:**

```
Usuario → Tech Lead: "Necesito 3 artículos sobre TypeScript"
           ↓
        Tech Lead: Evalúa carga de work
           ↓
        Tech Lead → Content Creator: "Crear 3 artículos"
           ↓
    Content Creator: Coordina búsqueda de fuentes
           ↓
    Entrega drafts listos para revisión
           ↓
        Tech Lead: Valida y aprueba para publicación
```

---

## 🗂️ Estructura de Carpetas

```
.opencode/
├── articles/
│   ├── drafts/
│   │   ├── ejemplo-articulo.md
│   │   ├── tipos-genericos-typescript.md
│   │   └── react-server-components.md
│   ├── published/  [futura]
│   └── archive/    [futura]
└── agents/
    ├── content-creator.md
    └── ...
```

---

## 🚀 Próximos Pasos

### Para Empezar:
1. Lee este documento por completo
2. Revisa el archivo de ejemplo: `ejemplo-articulo.md`
3. Lee la especificación completa: `content-creator.md`
4. Solicita tu primer artículo siguiendo el formato

### Para Optimizar:
1. Proporciona feedback después de cada artículo
2. Sugiere fuentes confiables nuevas
3. Comparte métricas de engagement de artículos publicados
4. Colabora con Content Creator en iteraciones

---

## 📚 Ejemplo de Salida

```markdown
✅ ARTÍCULO COMPLETADO

📄 Archivo: .opencode/articles/drafts/react-server-components.md

📊 Estadísticas:
- Palabras: 1,847
- Tiempo lectura: 9 minutos
- Imágenes: 2
- Fuentes: 4
- Tags: [React, Frontend, Next.js, Performance]

🎯 Mejoras realizadas:
- Ampliación: Agregados 3 ejemplos prácticos
- Imágenes: 2 imágenes de arquitectura desde Unsplash
- Referencias: Documentación oficial React, RFC Next.js
- Estructura: Intro → Conceptos → Implementación → Conclusión

📋 Validación: ✅ COMPLETADO
[x] Título 50 caracteres
[x] Slug URL-safe
[x] Summary 160 caracteres
[x] Content bien estructurado
[x] Imágenes verificadas
[x] Fuentes citadas
[x] Read time calculado
[x] Tags relevantes
[x] Sin errores
```

---

## ❓ Preguntas Frecuentes

**P: ¿Cuánto tarda crear un artículo?**
R: Típicamente 20-45 minutos dependiendo del tema y profundidad.

**P: ¿Puedo pedir cambios después?**
R: Sí, el archivo está en drafts. Puedes solicitar iteraciones.

**P: ¿Qué pasa con las imágenes?**
R: El Content Creator obtiene URLs de plataformas libres. Se guardan como referencias.

**P: ¿Cómo se calcula el tiempo de lectura?**
R: Fórmula: Math.ceil(wordCount / 200) = minutos estimados.

**P: ¿Puedo combinar con otros agentes?**
R: Sí. Tech Lead coordina múltiples agentes en paralelo para features complejas.

---

¡Estás listo para crear artículos de calidad! 🎉
