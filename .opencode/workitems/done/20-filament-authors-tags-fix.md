# Workitem 2: Corregir errores en módulos de Authors y Tags en Filament

## Problema
Los módulos de Authors (`/admin/authors`) y Tags (`/admin/tags`) muestran error `ArgumentCountError`:
- `Column::counts()` requiere exactamente 1 argumento (nombre de la relación)
- Error en `AuthorsTable.php` línea 31 y `TagsTable.php` línea 27

## Archivos afectados
- `app/Filament/Resources/Authors/Tables/AuthorsTable.php` (línea 31)
- `app/Filament/Resources/Tags/Tables/TagsTable.php` (línea 27)

## Causa
El método `counts()` se usa sin especificar el nombre de la relación a contar:
```php
->counts()  // INCORRECTO
```

## Solución
Cambiar a:
```php
->counts('articles')  // CORRECTO - especificar la relación
```

## Tareas
- [ ] Corregir `AuthorsTable.php` línea 31: cambiar `->counts()` por `->counts('articles')`
- [ ] Corregir `TagsTable.php` línea 27: cambiar `->counts()` por `->counts('articles')`
- [ ] Verificar que los módulos funcionan correctamente