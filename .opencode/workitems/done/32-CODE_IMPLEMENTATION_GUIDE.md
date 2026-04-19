# CÓDIGO A IMPLEMENTAR - Workitem #32

## 1️⃣ ARCHIVO: ArticleForm.php

**Ubicación:** `backend/app/Filament/Resources/Articles/Schemas/ArticleForm.php`

**Líneas a modificar:** 90-92

### ❌ CÓDIGO ACTUAL (INCORRECTO):

```php
TextInput::make('read_time')
    ->numeric()
    ->suffix('minutos'),
```

### ✅ CÓDIGO CORRECTO:

```php
TextInput::make('read_time')
    ->required()
    ->label('Tiempo de Lectura')
    ->numeric()
    ->default(5)
    ->minValue(1)
    ->maxValue(999)
    ->suffix('minutos')
    ->hint('Tiempo estimado de lectura en minutos'),
```

**Cambios realizados:**
- ✅ Agregado `->required()` - Campo obligatorio
- ✅ Agregado `->label('Tiempo de Lectura')` - Etiqueta clara
- ✅ Agregado `->default(5)` - Coincide con BD default
- ✅ Agregado `->minValue(1)` - Mínimo 1 minuto
- ✅ Agregado `->maxValue(999)` - Máximo 999 minutos
- ✅ Agregado `->hint()` - Ayuda contextual

---

## 2️⃣ ARCHIVO: ArticleRequest.php

**Ubicación:** `backend/app/Http/Requests/ArticleRequest.php`

### CAMBIO 1: Regla de Validación (línea 27)

**❌ ACTUAL:**
```php
'read_time' => 'nullable|integer|min:1',
```

**✅ CORRECTO:**
```php
'read_time' => 'required|integer|min:1|max:999',
```

### CAMBIO 2: Mensajes Personalizados (agregar después de línea 42)

**❌ ACTUAL:**
```php
public function messages(): array
{
    return [
        'title.required' => 'El título es requerido',
        'title.max' => 'El título no puede exceder 255 caracteres',
        'summary.required' => 'El resumen es requerido',
        'content.required' => 'El contenido es requerido',
        'main_image.required' => 'La imagen principal es requerida',
        'author_id.required' => 'El autor es requerido',
        'author_id.exists' => 'El autor seleccionado no existe',
        'tags.*.exists' => 'Una o más etiquetas seleccionadas no existen',
    ];
}
```

**✅ CORRECTO:**
```php
public function messages(): array
{
    return [
        'title.required' => 'El título es requerido',
        'title.max' => 'El título no puede exceder 255 caracteres',
        'summary.required' => 'El resumen es requerido',
        'content.required' => 'El contenido es requerido',
        'main_image.required' => 'La imagen principal es requerida',
        'author_id.required' => 'El autor es requerido',
        'author_id.exists' => 'El autor seleccionado no existe',
        'read_time.required' => 'El tiempo de lectura es requerido',
        'read_time.integer' => 'El tiempo de lectura debe ser un número entero',
        'read_time.min' => 'El tiempo de lectura debe ser al menos 1 minuto',
        'read_time.max' => 'El tiempo de lectura no puede exceder 999 minutos',
        'tags.*.exists' => 'Una o más etiquetas seleccionadas no existen',
    ];
}
```

**Cambios realizados:**
- ✅ Agregado mensaje para `read_time.required`
- ✅ Agregado mensaje para `read_time.integer`
- ✅ Agregado mensaje para `read_time.min`
- ✅ Agregado mensaje para `read_time.max`

---

## 🔍 VISTA COMPLETA - ArticleForm.php (línea 83-93)

```php
Section::make('Publicacion')
    ->schema([
        Toggle::make('is_published')
            ->default(false)
            ->label('Publicado'),
        DateTimePicker::make('published_at')
            ->label('Fecha de publicacion'),
        TextInput::make('read_time')                          // ← ACTUALIZAR
            ->required()                                      // ← NUEVO
            ->label('Tiempo de Lectura')                      // ← NUEVO
            ->numeric()
            ->default(5)                                      // ← NUEVO
            ->minValue(1)                                     // ← NUEVO
            ->maxValue(999)                                   // ← NUEVO
            ->suffix('minutos')
            ->hint('Tiempo estimado de lectura en minutos'),  // ← NUEVO
    ])->columns(3),
```

---

## 🔍 VISTA COMPLETA - ArticleRequest.php (línea 14-45)

```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'slug' => 'nullable|string|max:255|unique:articles,slug',
        'summary' => 'required|string',
        'content' => 'required|string',
        'main_image' => 'required|string|max:255',
        'embedded_images' => 'nullable|array',
        'embedded_images.*' => 'string',
        'video_url' => 'nullable|string|max:255',
        'author_id' => 'required|exists:authors,id',
        'published_at' => 'nullable|date',
        'read_time' => 'required|integer|min:1|max:999',  // ← CAMBIAR
        'tags' => 'nullable|array',
        'tags.*' => 'exists:tags,id',
    ];
}

public function messages(): array
{
    return [
        'title.required' => 'El título es requerido',
        'title.max' => 'El título no puede exceder 255 caracteres',
        'summary.required' => 'El resumen es requerido',
        'content.required' => 'El contenido es requerido',
        'main_image.required' => 'La imagen principal es requerida',
        'author_id.required' => 'El autor es requerido',
        'author_id.exists' => 'El autor seleccionado no existe',
        'read_time.required' => 'El tiempo de lectura es requerido',              // ← NUEVO
        'read_time.integer' => 'El tiempo de lectura debe ser un número entero',  // ← NUEVO
        'read_time.min' => 'El tiempo de lectura debe ser al menos 1 minuto',     // ← NUEVO
        'read_time.max' => 'El tiempo de lectura no puede exceder 999 minutos',   // ← NUEVO
        'tags.*.exists' => 'Una o más etiquetas seleccionadas no existen',
    ];
}
```

---

## ✅ VERIFICACIÓN POST-IMPLEMENTACIÓN

### Checklist de Validación:

- [ ] Archivo ArticleForm.php actualizado con ->required()
- [ ] Archivo ArticleForm.php tiene ->default(5)
- [ ] Archivo ArticleForm.php tiene ->minValue(1) y ->maxValue(999)
- [ ] Archivo ArticleRequest.php: 'read_time' => 'required|integer|min:1|max:999'
- [ ] Archivo ArticleRequest.php: Mensajes personalizados para read_time agregados
- [ ] Cambios sin errores PHP (validar sintaxis)
- [ ] Sin conflictos de git/merge

### Testing Manual:

1. **Test 1: Crear artículo SIN read_time**
   - Ir a Filament → Articles → Create
   - Completar todos los campos EXCEPTO read_time
   - Click "Save"
   - ✅ Esperado: Mensaje de error "El tiempo de lectura es requerido"
   - ❌ NO esperado: Error SQL

2. **Test 2: Crear artículo CON read_time**
   - Ir a Filament → Articles → Create
   - Completar TODOS los campos incluyendo read_time = 10
   - Click "Save"
   - ✅ Esperado: Artículo guardado, ver en lista

3. **Test 3: Editar artículo existente**
   - Ir a Filament → Articles → [Seleccionar]
   - Cambiar título
   - Dejar read_time igual
   - Click "Save"
   - ✅ Esperado: Cambios guardados, read_time intacto

---

## 📝 NOTAS IMPORTANTES

1. **Sintaxis Filament:** Los métodos se encadenan con `->`, el orden no importa pero se sugiere:
   - `->required()` primero
   - `->label()` para claridad
   - `->type()` (numeric)
   - `->default()` y validaciones (minValue, maxValue)
   - `->suffix()` y `->hint()` al final

2. **BD:** NO cambia la migración, ya es correcta con `->default(5)`

3. **Compatibilidad:** Estos cambios son backwards compatible, solo agregarán validación

4. **Frontend Filament:** Automáticamente mostrará asterisco (*) indicando campo requerido

---

**Versión:** 1.0  
**Creado:** 2026-04-19  
**Para:** Workitem #32
