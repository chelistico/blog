# 32 - Fix: Agregar Validación Requerida para Campo "Read Time" en Artículos

## Descripción del Problema

Cuando el usuario intenta crear un artículo en Filament sin completar el campo **"Read time"**, el sistema genera un error SQL:

```
SQLSTATE[23000]: Integrity constraint violation: 1048 Column 'read_time' cannot be null
```

**Causa:** El campo `read_time` es **obligatorio** en la base de datos (NOT NULL con default), pero:
1. ❌ El formulario Filament NO tiene validación `->required()`
2. ❌ Las reglas de validación backend permiten valores nulos (`'read_time' => 'nullable|integer|min:1'`)
3. ❌ No hay mensaje claro al usuario indicando que debe completar este campo

## Requisitos Técnicos

### Backend - Filament Form Validation
**Archivo:** `backend/app/Filament/Resources/Articles/Schemas/ArticleForm.php`

Actualizar el campo `read_time` (línea 90-92) para:
- ✅ Agregar `->required()` para hacer el campo obligatorio
- ✅ Agregar mensaje personalizado `->requiredMessage('El tiempo de lectura es requerido')`
- ✅ Mantener validación `->numeric()` y `->suffix('minutos')`
- ✅ Considerar agregar valor por defecto `->default(5)` (coincide con BD)

**Código actual (línea 90-92):**
```php
TextInput::make('read_time')
    ->numeric()
    ->suffix('minutos'),
```

**Código esperado:**
```php
TextInput::make('read_time')
    ->required()
    ->requiredMessage('El tiempo de lectura es requerido')
    ->numeric()
    ->default(5)
    ->suffix('minutos')
    ->minValue(1)
    ->maxValue(999),
```

### Backend - Request Validation Rules
**Archivo:** `backend/app/Http/Requests/ArticleRequest.php`

Actualizar la regla de validación (línea 27) de:
```php
'read_time' => 'nullable|integer|min:1',
```

A:
```php
'read_time' => 'required|integer|min:1|max:999',
```

Y agregar mensaje personalizado en `messages()`:
```php
'read_time.required' => 'El tiempo de lectura es requerido',
'read_time.integer' => 'El tiempo de lectura debe ser un número entero',
'read_time.min' => 'El tiempo de lectura debe ser al menos 1 minuto',
'read_time.max' => 'El tiempo de lectura no puede exceder 999 minutos',
```

## Especificación Técnica

### Cambios Requeridos

| Archivo | Línea | Cambio | Prioridad |
|---------|-------|--------|-----------|
| ArticleForm.php | 90-92 | Agregar `->required()` y `->default(5)` | ALTA |
| ArticleRequest.php | 27 | Cambiar `nullable` a `required` | ALTA |
| ArticleRequest.php | 34-45 | Agregar mensajes para `read_time` | MEDIA |

### Validación HTML5
- El campo debe tener atributo `required` en HTML
- Filament lo maneja automáticamente con `->required()`
- Mensaje de validación debe ser claro y en español

### Base de Datos
- ✅ Ya está correcta: `$table->integer('read_time')->default(5);`
- No requiere cambios en migraciones

## Criterios de Aceptación

- [ ] Campo `read_time` tiene validación `->required()` en ArticleForm
- [ ] Campo `read_time` tiene valor por defecto `->default(5)` en formulario
- [ ] Regla de validación backend cambiada de `nullable` a `required`
- [ ] Mensajes personalizados agregados en 4 idiomas/contextos (required, integer, min, max)
- [ ] Al crear artículo sin "Read time", se muestra error descriptivo en UI
- [ ] Al crear artículo CON "Read time", funciona correctamente
- [ ] Artículos existentes no se afectan
- [ ] Edición de artículos funciona correctamente

## Testing Manual

### Caso 1: Crear artículo sin "Read time"
1. Ir a Filament → Articles → Create
2. Completar: title, summary, content, author, main_image
3. Dejar vacío: read_time
4. Click "Save"
5. ✅ Esperado: Aparece mensaje de error "El tiempo de lectura es requerido"
6. ❌ Actual: Error SQL genérico

### Caso 2: Crear artículo con "Read time"
1. Repetir caso 1
2. Completar read_time = 5
3. Click "Save"
4. ✅ Esperado: Artículo guardado exitosamente

### Caso 3: Editar artículo existente
1. Ir a Filament → Articles → [Seleccionar artículo]
2. Modificar otros campos
3. No tocar read_time
4. Click "Save"
5. ✅ Esperado: Cambios guardados, read_time sin cambios

## Timeline

- **Estimación:** 30 minutos
- **Complejidad:** ⭐ Simple
- **Componentes afectados:** 2 archivos (Filament Form, Validation Rules)

## Prioridad

🔴 **ALTA** - Impide crear artículos en Filament

## Referencias

- **Modelo:** `backend/app/Models/Article.php` (línea 25)
- **Migración:** `backend/database/migrations/2024_01_01_000005_create_articles_table.php` (línea 22)
- **Controlador:** `backend/app/Http/Controllers/Admin/AdminArticleController.php`
- **Documentación Filament:** https://filamentphp.com/docs/forms/fields/text-input

## Notas Adicionales

- El campo `read_time` representa minutos de lectura estimada
- El default en BD es 5 minutos (línea 22 de migration)
- Es recomendable que coincida el default en el formulario
- Considerar agregar ayuda: `->hint('Tiempo estimado de lectura en minutos')`

---

**Estado:** 🔴 Pendiente  
**Asignado a:** backend-laravel12  
**Creado:** 2026-04-19  
**Última actualización:** 2026-04-19
