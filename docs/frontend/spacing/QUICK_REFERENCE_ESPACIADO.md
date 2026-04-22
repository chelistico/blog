# 🚀 Quick Reference - Espaciado en ArticleContent

## 📝 Cambios Rápidos

### ArticleContent.tsx - Clases Prose
```typescript
className="prose prose-lg max-w-none
  // Headings
  prose-h2:mt-10 prose-h2:mb-6    // Antes: mt-8 mb-4
  prose-h3:mt-8 prose-h3:mb-5     // Antes: mt-6 mb-3
  
  // Párrafos - LO MÁS IMPORTANTE
  prose-p:mb-6                    // Antes: mb-4 (+50%)
  
  // Listas
  prose-li:mb-3                   // Antes: mb-2 (+50%)
  prose-ol:mb-6                   // Nuevo
  
  // Especiales
  prose-blockquote:my-6           // Nuevo
  prose-pre:my-6"                 // Nuevo
```

### index.css - Pre Block
```css
pre {
  @apply bg-slate-950 border border-slate-800 rounded-lg 
         overflow-x-auto shadow-xl py-4 px-4;  /* py-4 px-4 son nuevos */
}
```

---

## 🎯 Guía de Valores

| Clase | Valor | Uso |
|-------|-------|-----|
| mb-3 | 0.75rem (12px) | Items de lista |
| mb-4 | 1rem (16px) | ❌ Ya no usado |
| **mb-6** | **1.5rem (24px)** | ✅ **Párrafos** |
| mb-5 | 1.25rem (20px) | Headings h3 |
| mt-8 | 2rem (32px) | Headings h3 |
| **mt-10** | **2.5rem (40px)** | ✅ **Headings h2** |
| my-6 | 1.5rem arriba/abajo | Code, blockquotes |
| py-4 | 1rem arriba/abajo | Padding interno pre |

---

## 🔍 Dónde Está Implementado

```
frontend/src/
├── components/
│   └── ArticleContent.tsx (líneas 47-57) ✅
└── index.css (línea 8) ✅
```

---

## ✅ Checklist para Futuros Cambios

Si necesitas modificar espaciado en el futuro:

1. **Busca `ArticleContent.tsx`**
   - Modifica las clases `prose-*:` en el className
   - Usa Tailwind spacing scale (mb-4, mb-5, mb-6, etc)

2. **Busca `index.css`**
   - Modifica la regla `@layer components { pre { ... } }`
   - Mantén el padding consistente con Tailwind

3. **Valida cambios**
   ```bash
   npm run typecheck
   npm run build
   ```

4. **Verifica visualmente**
   - Abre un artículo en dev
   - Comprueba que el espaciado se ve bien

---

## 💡 Tips

- **mb-6** = 1.5rem = la mejor opción para párrafos
- **my-6** = para elementos que necesitan espacio arriba Y abajo
- **py-4, px-4** = padding interno de 1rem (bueno para código)
- **mt-10, mt-8** = headings pueden tener más margin-top que margin-bottom

---

## 📚 Referencias Rápidas

- [Tailwind Spacing](https://tailwindcss.com/docs/margin)
- [Prose Plugin](https://tailwindcss.com/docs/typography-plugin)
- Git Commit: `2878c39`

---

## 🎨 Visualización Rápida

```
[Párrafo]      mb-6 = 1.5rem espaciado
[Párrafo]      ↓
[Párrafo]      
               my-6 = 1.5rem espaciado arriba y abajo
[Código con py-4 px-4 padding interno]
               my-6 = 1.5rem espaciado arriba y abajo
[Párrafo]
```

¡Fácil de recordar! ✨
