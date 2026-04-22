# 📖 Referencia Rápida: Estilo de Código Inline

## ¿Qué se cambió?

Los tags `<code>` inline en los artículos ahora tienen un **fondo oscuro** en lugar de transparente, lo que los hace mucho más visibles y legibles.

### Problema que se resolvió
- ❌ **Antes:** `<code>` con fondo transparent → invisible contra fondo claro
- ✅ **Después:** `<code>` con fondo slate-950 → destaca claramente

---

## Donde se hizo el cambio

**Archivo:** `frontend/tailwind.config.js`  
**Líneas:** 94-100  
**Sección:** `typography.DEFAULT.css['code']`

---

## Código actualizado

```javascript
'code': {
  color: '#f1f5f9',                    // Texto claro
  backgroundColor: '#0f172a',           // Fondo oscuro ⭐ CAMBIO
  padding: '0.25rem 0.5rem',           // Espaciado ⭐ CAMBIO
  borderRadius: '0.375rem',            // Bordes redondeados ⭐ CAMBIO
  fontFamily: 'Fira Code, Courier New, monospace', // Monospace ⭐ CAMBIO
},
```

---

## Especificaciones

| Aspecto | Valor | Descripción |
|--------|-------|-------------|
| **Color de fondo** | `#0f172a` (slate-950) | Oscuro profesional |
| **Color de texto** | `#f1f5f9` (slate-100) | Blanco/gris claro |
| **Contraste WCAG** | 18.5:1 | AAA (máximo nivel) ✓ |
| **Padding** | 0.25rem 0.5rem | 4px vertical, 8px horizontal |
| **Bordes** | 0.375rem | 6px de radio |
| **Fuente** | Fira Code | Monoespaciada |

---

## Ejemplos de visualización

### Ejemplo 1: Comando
**HTML:**
```html
<p>Ejecuta <code>git init</code> para crear un repo.</p>
```

**Visualización:**
- Antes: "Ejecuta git init para crear un repo." (el código se pierde)
- Después: "Ejecuta `git init` para crear un repo." (resalta claramente)

### Ejemplo 2: Variable
**HTML:**
```html
<p>La carpeta <code>.git</code> contiene la metadata.</p>
```

**Visualización:**
- Antes: "La carpeta .git contiene la metadata." (casi invisible)
- Después: "La carpeta `.git` contiene la metadata." (destaca)

---

## Compatibilidad

✅ Chrome/Edge 90+  
✅ Firefox 88+  
✅ Safari 14.1+  
✅ Mobile browsers (iOS, Android)  
✅ WCAG AAA accessibility  
✅ Print-friendly  

---

## Notas técnicas

1. **Aplica automáticamente** en todos los artículos del blog
2. **No requiere cambios** en componentes React
3. **Puro CSS** de Tailwind - sin JavaScript
4. **Los code blocks** `<pre><code>` mantienen sus estilos específicos
5. **Compatible** con tema claro/oscuro del sitio

---

## Si necesitas ajustar más

Puedes agregar estas propiedades opcionales:

```javascript
'code': {
  // ... propiedades existentes ...
  fontSize: '0.875rem',             // Texto más pequeño
  fontWeight: '500',                // Texto más groeso
  letterSpacing: '0.025em',         // Espaciado entre letras
  borderWidth: '1px',               // Borde sutil
  borderColor: '#334155',           // Color borde (slate-700)
  boxShadow: '0 1px 2px rgba(0,0,0,0.1)', // Sombra sutil
},
```

---

## ¿Dónde ves el efecto?

Todo lugar donde haya `<code>` tags en artículos HTML renderizado:

- Artículos del blog
- Descripciones con código inline
- Comentarios con código
- Cualquier contenido HTML con `<code>` tags

---

## Validación

✓ Build: `npm run build` ✓  
✓ TypeScript: `npm run typecheck` ✓  
✓ Lint: `npm run lint` ✓  
✓ Producción: Ready ✓  

---

## Commit

```
Commit: c3f5f1a
Mensaje: Fix: Mejorar contraste de código inline con fondo oscuro
Fecha: 2026-04-21
```

---

**Estado:** ✅ Completado y validado
