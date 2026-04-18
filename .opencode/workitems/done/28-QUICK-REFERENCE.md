# ⚡ QUICK REFERENCE: Workitem #28 Implementation

**Advertisement Visibility Optimization**  
*Para copiar y pegar rápidamente durante implementación*

---

## TL;DR

**Problema:** Mostrar espacio vacío con "No hay anuncios disponibles"  
**Solución:** No renderizar nada (`return null`)  
**Archivo:** `frontend/src/components/AdvertisementBanner.tsx`  
**Esfuerzo:** 15-30 minutos  

---

## Cambios Exactos

### Localización

**Archivo:** `/frontend/src/components/AdvertisementBanner.tsx`  
**Sección:** Render function (approx líneas 164-201)  

### Cambio 1: Loading State

**BUSCAR:**
```typescript
if (isLoading) {
  return (
    <div className="w-full flex justify-center py-4">
      <div className="w-full max-w-[728px] h-[90px] bg-gray-200 rounded animate-pulse" />
    </div>
  );
}
```

**REEMPLAZAR CON:**
```typescript
if (isLoading) {
  return null;
}
```

### Cambio 2: Error State

**BUSCAR:**
```typescript
if (error) {
  return (
    <div className={`text-center text-sm text-gray-400 p-4 ${className}`}>
      No pudimos cargar los anuncios para esta posición: {position}
    </div>
  );
}
```

**REEMPLAZAR CON:**
```typescript
if (error) {
  return null;
}
```

### Cambio 3: No Ads Available

**BUSCAR:**
```typescript
if (advertisements.length === 0) {
  return (
    <div className={`text-center text-sm text-gray-400 p-4 ${className}`}>
      No hay anuncios disponibles para esta posición
    </div>
  );
}
```

**REEMPLAZAR CON:**
```typescript
if (advertisements.length === 0) {
  return null;
}
```

---

## Cambio Opcional: Logging

**AGREGAR EN USEEFFECT** (después de efectos de ads):

```typescript
// Debug logging
if (advertisements.length === 0 && !isLoading && !error) {
  console.debug(
    `[AdvertisementBanner] No advertisements for position: "${position}"`
  );
}

if (error) {
  console.error(
    `[AdvertisementBanner] Ad loading error for position "${position}":`,
    error
  );
}
```

---

## Verificación Rápida

### Build
```bash
npm run build
```
✅ Debe compilar sin errores

### Lint
```bash
npm run lint
```
✅ Debe pasar sin warnings

### Type Check
```bash
npm run type-check
# o
tsc --noEmit
```
✅ Debe pasar sin errores

---

## Testing Local

### Escenario 1: CON Anuncios ✅
- [ ] Navegar a home page
- [ ] Verificar que se muestra el anuncio
- [ ] Click en anuncio funciona
- [ ] Imagen visible

### Escenario 2: SIN Anuncios ✅
- [ ] Ir a admin y desactivar todos los ads
- [ ] Recargar home page
- [ ] Verificar que NO hay espacio vacío
- [ ] Verificar que NO hay mensaje "No hay anuncios"
- [ ] Contenido está pegado al header

### Escenario 3: Mobile ✅
- [ ] DevTools → Mobile emulation (375x667)
- [ ] Recargar página
- [ ] Verificar responsive sin gaps innecesarios
- [ ] Contenido fluye bien

---

## Rollback (Si es Necesario)

```bash
# Revertir cambios
git checkout frontend/src/components/AdvertisementBanner.tsx

# O restaurar de backup
cp frontend/src/components/AdvertisementBanner.tsx.backup \
   frontend/src/components/AdvertisementBanner.tsx
```

---

## GIT Commands

```bash
# Crear rama si no existe
git checkout -b workitem/28-ad-visibility

# Después de cambios
git add frontend/src/components/AdvertisementBanner.tsx
git commit -m "feat(ads): hide advertisement space when not available

- Return null instead of showing empty ad space
- Removes 'No hay anuncios disponibles' message
- Adds debug logging for ad availability
- Improves page layout and UX"

# Push
git push origin workitem/28-ad-visibility
```

---

## Debugging Tips

### Ver logs en console
```javascript
// En navegador console:
console.debug() → Búscar "[AdvertisementBanner]"
```

### Verificar BD tiene anuncios
```bash
# Backend
php artisan tinker
Advertisement::where('position', 'top')->where('is_active', true)->get();
```

### Network inspection
1. DevTools → Network
2. Buscar `/api/advertisements?position=top`
3. Verificar response vacío o con datos

### Cache limpieza
```javascript
// En browser console:
advertisementService.clearCache();
// Luego recargar página
```

---

## Validación Final

| Item | Status |
|------|--------|
| Cambios de código | ✅ |
| Build exitoso | ✅ |
| Lint pasando | ✅ |
| TypeScript OK | ✅ |
| Testing local | ✅ |
| Mobile responsive | ✅ |
| Console limpia | ✅ |
| No regressions | ✅ |

---

## Archivos Relacionados (Para Referencia)

- `frontend/src/components/AdvertisementBanner.tsx` → Archivo a modificar
- `frontend/src/services/advertisementService.ts` → Service (no cambiar)
- `frontend/src/components/Layout.tsx` → Uso del componente (no cambiar)
- `frontend/src/types/advertisement.ts` → Types (no cambiar)

---

## Resumen de Cambios

```
ANTES:
if (advertisements.length === 0) {
  return <div>No hay anuncios disponibles para esta posición</div>
}

DESPUÉS:
if (advertisements.length === 0) {
  return null
}

Total: 3 cambios similares (loading, error, no ads)
```

---

## Tiempo Estimado por Tarea

| Tarea | Tiempo |
|-------|--------|
| Hacer cambios | 10 min |
| Verificar build | 5 min |
| Testing local | 20 min |
| Debugging (si needed) | 10 min |
| **TOTAL** | **45 min** |

---

## Success Indicators ✅

```
□ Código compilado sin errores
□ Sin console warnings/errors
□ Ads se muestran cuando existen
□ Espacio desaparece cuando no hay ads
□ Responsive en mobile/desktop
□ Loading no muestra skeleton
□ Errors no muestran mensajes
□ Logging disponible en console
```

---

## Preguntas en Implementación

**P: No encuentro la línea exacta**  
→ Buscar: `No hay anuncios disponibles para esta posición`

**P: Cambio pero sigue mostrando espacio**  
→ Limpiar caché browser (Ctrl+Shift+Delete)

**P: Quiero ver qué pasó**  
→ Abrir DevTools Console (F12) y buscar `[AdvertisementBanner]`

**P: Necesito revertir**  
→ `git checkout frontend/src/components/AdvertisementBanner.tsx`

---

## Documentación Completa

Para más detalles:
- 📋 [28-advertisement-visibility-optimization.md](28-advertisement-visibility-optimization.md) - Workitem completo
- 📖 [28-EXECUTIVE-SUMMARY.md](28-EXECUTIVE-SUMMARY.md) - Resumen rápido
- 📊 [28-ANALYSIS-DETAILED.md](28-ANALYSIS-DETAILED.md) - Análisis detallado

---

**Status:** 🟢 Ready to implement  
**Created:** April 18, 2026  
**Last Updated:** April 18, 2026
