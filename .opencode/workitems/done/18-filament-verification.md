# Workitem: 06-verification

## Fase 6: Verificación y Testing

### Objetivo
Verificar que todas las funcionalidades del panel admin estén correctas.

---

## Checklist de Verificación

### Autenticación
- [ ] Login funciona con credenciales admin
- [ ] Logout funciona
- [ ] Sesiones persisten correctamente
- [ ] Usuarios no autenticados son redirigidos al login

### Gestión de Artículos
- [ ] Crear artículo nuevo
- [ ] Editar artículo existente
- [ ] Eliminar artículo
- [ ] Publicar/despublicar artículo
- [ ] Asignar tags
- [ ] Asignar autor
- [ ] Editor Tiptap funciona (negrita, cursiva, código, etc.)
- [ ] Subir imágenes en editor

### Gestión de Tags
- [ ] Crear tag
- [ ] Editar tag
- [ ] Eliminar tag (verificar que no tenga artículos)
- [ ] Tags aparecen en lista de artículos

### Gestión de Autores
- [ ] Crear autor
- [ ] Editar perfil
- [ ] Agregar links de redes sociales
- [ ] Activar/desactivar autor

### Gestión de Publicidades
- [ ] Crear anuncio con imagen
- [ ] Crear anuncio con código AdSense
- [ ] Programar fecha de inicio/fin
- [ ] Cambiar orden de anuncios

### Gestión del Footer
- [ ] Crear items de footer
- [ ] Organizar por secciones
- [ ] Agregar links externos
- [ ] Reordenar items

### Configuraciones
- [ ] Modificar site_name
- [ ] Modificar SEO settings
- [ ] Cambiar logo

### Dashboard
- [ ] Widgets cargan correctamente
- [ ] Estadísticas son exactas
- [ ] Gráficos se muestran

---

## Comandos de Verificación

```bash
# Verificar que Filament está funcionando
curl -I http://blog-api.local/admin

# Ver recursos registrados
docker exec -w /var/www/html/blog/backend docker_php84 php artisan filament:list-resources

# Limpiar cachés si hay problemas
docker exec -w /var/www/html/blog/backend docker_php84 php artisan optimize:clear
```

---

## Problemas Comunes y Soluciones

### Error 500 en /admin
```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan optimize:clear
docker exec -w /var/www/html/blog/backend docker_php84 php artisan cache:clear
```

### Recursos no aparecen en el menú
- Verificar que el modelo tenga los traits correctos
- Verificar namespace del recurso

### Imágenes no suben
```bash
# Verificar permisos de storage
docker exec docker_php84 chmod -R 775 /var/www/html/blog/backend/storage/app/public/images
```

---

## URLs de Prueba

| URL | Descripción |
|-----|-------------|
| http://blog-api.local/admin | Panel admin |
| http://blog-api.local/admin/articles | Gestión de artículos |
| http://blog-api.local/admin/tags | Gestión de tags |
| http://blog-api.local/admin/authors | Gestión de autores |

---

## Siguiente Paso
Una vez verificado, el panel admin está listo para uso.

## Documentación Adicional

- [Documentación oficial Filament](https://filamentadmin.com/docs/)
- [Filament v3 GitHub](https://github.com/filamentphp/filament)
