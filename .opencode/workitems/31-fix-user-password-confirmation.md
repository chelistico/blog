# Workitem #31: Error de validación "validation.confirmed" al crear usuario

## Problema
Al intentar crear un usuario nuevo, después de completar el campo Password y enviar el formulario, se obtiene un error de validación rojo en el frontend: "validation.confirmed". El usuario no puede ser creado.

## Causa Raíz
El formulario tiene la validación `.confirmed()` en el campo password (línea 40 de `UserForm.php`), pero falta el campo correspondiente para confirmar la contraseña. Filament espera un campo `password_confirmation` que no existe en el formulario.

Archivos afectados:
- `backend/app/Filament/Resources/Users/Schemas/UserForm.php` - Línea 36-40

## Solución
Agregar un campo TextInput para la confirmación de contraseña después del campo password original. Este campo debe tener las siguientes características:
- Label: "Confirmar Contraseña" (o similar)
- Type: password
- Must match password field
- Required cuando password está filled

## Pasos a Realizar
1. Editar `backend/app/Filament/Resources/Users/Schemas/UserForm.php`
2. Agregar componente `TextInput::make('password_confirmation')` después del campo password
3. Configurar para que sea password input
4. Probar creación de usuario con contraseña
5. Probar que la validación de confirmación funciona (error si no coinciden)

## Adicional
- Cuando se edita a un usuario existente, actualmente se ve el campo Password, pero hay que contemplar que cuando se ingresa a la edición de un usuario puede ser que no se desee el cambio de contraseña. Se puede configurar el campo password para que solo sea requerido si se está creando un nuevo usuario, y opcional al editar. Esto se puede hacer con `->required(fn ($livewire) => $livewire instanceof CreateUser)` o similar.

## Status
Pending
