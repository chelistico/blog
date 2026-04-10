# Workitem: Revisar y mejorar estilo del Admin con Filament

## Problemas identificados

### 1. Cards desproporcionadas
**Archivos:** 
- `app/Filament/Widgets/ArticlesByStatus.php`
- `app/Filament/Widgets/PopularArticles.php`

**Causa:** Los widgets tienen `$columnSpan = 6`, lo que hace que ocupen la mitad del ancho disponible. Esto causa desproporción con otros elementos del Dashboard.

**Solución:** Ajustar el columnSpan a valores más pequeños (ej: 3) o usar clases CSS adicionales para controlar el ancho.

### 2. Link "Ver sitio" incorrecto
**Archivo:** `resources/views/filament/admin/sidebar-footer.blade.php`

**Causa:** El link tiene `href="/"` que redirige al mismo dominio del admin (`http://blog-api.local/`) en vez del frontend (`http://localhost:5173/`).

**Solución:** Cambiar el href a la URL del frontend (`http://localhost:5173/`).

## Tareas
- [ ] Ajustar columnSpan de ArticlesByStatus y PopularArticles
- [ ] Corregir URL del link "Ver sitio" en sidebar-footer.blade.php