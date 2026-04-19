# Workitem #29: Error de integridad "avatar cannot be null" al crear Author

## Problema
Al intentar crear un Author nuevo, se obtiene error SQL:
```
SQLSTATE[23000]: Integrity constraint violation: 1048 
Column 'avatar' cannot be null
```

El campo avatar está marcado como NOT NULL en la base de datos pero no hay validación en el formulario.

## Causa Raíz
El campo `avatar` en la migración `2024_01_01_000003_create_authors_table.php` es NOT NULL (línea 15), pero el formulario en `AuthorForm.php` no lo marca como requerido. Cuando se envía el formulario sin llenar el avatar, intenta guardar NULL en una columna que no lo permite.

Archivos afectados:
- `backend/database/migrations/2024_01_01_000003_create_authors_table.php` - Línea 15
- `backend/app/Filament/Resources/Authors/Schemas/AuthorForm.php` - Línea 26-28
- `backend/app/Models/Author.php` - Para verificar que sea llenado

## Solución

### Incluir un avatar default o permitir avatar nullable
Si el usuario no sube un avatar, se puede asignar un avatar default (ej. una imagen genérica) para evitar el error de integridad. Esto se puede hacer en el modelo Author usando un accessor o en el controlador antes de guardar.

## Status
Pending
