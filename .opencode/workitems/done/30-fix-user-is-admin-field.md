# Workitem #30: Campo is_admin no se guarda en Users

## Problema
Cuando se edita un usuario con admin@techdaily.com y se activa el switch "Es Admin", el formulario se envía sin errores pero el campo `users.is_admin` continúa en 0.

## Causa Raíz
El modelo `User` no tiene el campo `is_admin` en su atributo `#[Fillable]`. El campo se define en la migración pero no está siendo asignado al modelo.

Archivos afectados:
- `backend/app/Models/User.php` - Línea 15: `#[Fillable(['name', 'email', 'password', 'role'])]`

## Solución
1. Agregar `'is_admin'` al array de campos fillable en el modelo User
2. Verificar que la migración de users tenga el campo `is_admin` como NOT NULL
3. Probar que el switch funcione correctamente tanto en crear como en editar

## Pasos a Realizar
1. Editar `backend/app/Models/User.php`
2. Agregar `'is_admin'` al Fillable attribute
3. Ejecutar pruebas manuales en el admin para verificar que se guarda correctamente
4. Verificar que el usuario admin@techdaily.com ahora puede cambiar este campo

## Status
Pending
