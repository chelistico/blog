---
title: "Domina Git: Guía Completa de Comandos Esenciales"
slug: "domina-git-guia-completa-comandos-esenciales"
summary: "Aprende los comandos Git más importantes para controlar versiones, colaborar en equipos y mantener un historial limpio de tu código. Desde la inicialización hasta operaciones avanzadas."
main_image: "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=1200&h=800&fit=crop"
embedded_images:
  - "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=1200&h=800&fit=crop"
  - "https://images.unsplash.com/photo-1555949519-46ba40dd5a2c?w=1200&h=800&fit=crop"
  - "https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800&h=600&fit=crop"
author_name: "Especialista en DevOps"
author_slug: "especialista-devops"
tags:
  - "Git"
  - "Control de Versiones"
  - "Desarrollo"
  - "DevOps"
  - "Colaboración"
read_time: 12
---

# Domina Git: Guía Completa de Comandos Esenciales

## Introducción

En el mundo del desarrollo de software moderno, el control de versiones es fundamental. Git, creado por Linus Torvalds en 2005, se ha convertido en el estándar de facto para la gestión de código fuente. Ya sea que trabajes en un proyecto personal o en un equipo de cientos de desarrolladores, dominar Git es una habilidad imprescindible que te permitirá colaborar de manera efectiva, mantener un historial limpio de cambios y recuperarte de errores de forma rápida.

Este artículo te guiará a través de los comandos Git más esenciales, organizados de manera lógica para que puedas entenderlos progresivamente, desde operaciones básicas hasta técnicas avanzadas. No importa si eres principiante o desarrollador experimentado, aquí encontrarás referencias prácticas que puedes usar diariamente.

## 1. Iniciando con Git

Antes de trabajar con Git, necesitas aprender cómo crear o clonar un repositorio. Estos comandos son el punto de partida para cualquier proyecto.

### `git init` - Crear un nuevo repositorio

**Descripción:** Inicializa un nuevo repositorio Git en el directorio actual. Esto crea una carpeta oculta `.git` que contiene toda la información de versioning.

**Ejemplo de uso:**
```bash
# Crear un nuevo proyecto
mkdir mi-proyecto
cd mi-proyecto
git init
```

Este comando es ideal cuando comienzas un proyecto nuevo desde cero. Después de ejecutarlo, Git comenzará a rastrear cambios en todos los archivos del directorio.

### `git clone [url]` - Clonar un repositorio remoto

**Descripción:** Descarga una copia completa de un repositorio remoto en tu máquina local, incluyendo todo el historial de cambios.

**Ejemplo de uso:**
```bash
# Clonar un repositorio de GitHub
git clone https://github.com/usuario/mi-proyecto.git

# Clonar a una carpeta específica
git clone https://github.com/usuario/mi-proyecto.git mi-carpeta-personalizada
```

Cuando clonas un repositorio, Git automáticamente:
- Descarga todo el historial del proyecto
- Configura el repositorio remoto como "origin"
- Crea una rama local que rastrea la rama remota principal

---

## 2. Verificar el Estado del Repositorio

Entender el estado actual de tu repositorio es fundamental para tomar decisiones sobre qué cambios hacer y cuándo confirmarlos.

### `git status` - Ver el estado actual

**Descripción:** Muestra información detallada sobre archivos modificados, sin seguimiento, preparados para commit, y el estado de tu rama actual.

**Ejemplo de uso:**
```bash
git status

# Salida típica:
# On branch main
# 
# No commits yet
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#     README.md
#     index.js
#
# nothing added to commit but untracked files present (tracked will be taken into account)
```

### `git status --short` - Vista compacta del estado

**Descripción:** Proporciona el mismo estado pero en un formato más conciso, ideal para terminales con espacio limitado.

**Ejemplo de uso:**
```bash
git status --short

# Salida típica:
#  M package.json        (Modificado)
# ?? src/app.js          (Sin seguimiento)
# D  config.json         (Eliminado)
#  A index.js            (Preparado para commit)
```

Los códigos de estado:
- `??` - Archivo sin seguimiento
- `M` - Modificado
- `A` - Preparado (added)
- `D` - Eliminado

---

## 3. Preparar y Confirmar Cambios

El flujo de trabajo básico en Git involucra preparar cambios (staging) y luego confirmarlos (commit) con un mensaje descriptivo.

### `git add [archivo]` - Preparar un archivo

**Descripción:** Añade un archivo específico al área de preparación (staging area), indicando que deseas incluirlo en el próximo commit.

**Ejemplo de uso:**
```bash
# Preparar un archivo específico
git add src/componentes/Header.jsx

# Preparar múltiples archivos
git add src/componentes/Header.jsx src/utilidades/helper.js
```

### `git add .` - Preparar todos los cambios locales

**Descripción:** Añade todos los archivos modificados en el directorio actual y subdirectorios al área de preparación, excepto los explícitamente ignorados.

**Ejemplo de uso:**
```bash
git add .
```

⚠️ **Nota:** `git add .` no incluye archivos eliminados. Para incluirlos, usa `git add -A`.

### `git add -A` - Preparar todos los cambios (incluyendo eliminados)

**Descripción:** Añade todos los cambios del repositorio completo, incluyendo archivos nuevos, modificados y eliminados.

**Ejemplo de uso:**
```bash
git add -A
```

### `git commit -m "mensaje"` - Crear un commit

**Descripción:** Confirma los cambios preparados (staged) con un mensaje descriptivo que explique qué se cambió y por qué.

**Ejemplo de uso:**
```bash
# Commit simple
git commit -m "Añadir componente Header"

# Commit con descripción detallada
git commit -m "Refactor: optimizar carga de imágenes

- Implementar lazy loading
- Reducir tamaño de imágenes comprimidas
- Mejora de rendimiento en móviles"
```

💡 **Buena Práctica:** Escribe mensajes de commit en tiempo presente e imperitivo. Sé conciso pero descriptivo. Los desarrolladores leerán estos mensajes meses o años después.

---

## 4. Trabajar con Ramas

Las ramas permiten desarrollar características de forma aislada sin afectar el código principal. Es un concepto fundamental en flujos de trabajo colaborativos.

### `git branch` - Listar ramas locales

**Descripción:** Muestra todas las ramas locales, marcando con un asterisco la rama actual.

**Ejemplo de uso:**
```bash
git branch

# Salida típica:
#   develop
# * main
#   feature/auth
```

### `git branch -r` - Listar ramas remotas

**Descripción:** Muestra todas las ramas que existen en el repositorio remoto (origin).

**Ejemplo de uso:**
```bash
git branch -r

# Salida típica:
#   origin/main
#   origin/develop
#   origin/feature/auth
```

### `git ls-remote --heads origin` - Ver ramas remotas con más detalles

**Descripción:** Alternativa más robusta para listar ramas remotas, especialmente útil para repositorios con muchas ramas.

**Ejemplo de uso:**
```bash
git ls-remote --heads origin

# Salida típica:
# abc123def    refs/heads/main
# xyz789abc    refs/heads/develop
# 456def789    refs/heads/feature/auth
```

### `git branch [nombre]` - Crear una nueva rama

**Descripción:** Crea una nueva rama con el nombre especificado, partiendo desde el commit actual.

**Ejemplo de uso:**
```bash
# Crear rama para una nueva característica
git branch feature/autenticacion

# Crear rama para corrección de bug
git branch bugfix/validacion-email
```

La nueva rama es una copia del estado actual y no afecta tu rama actual.

### `git checkout [rama]` - Cambiar de rama

**Descripción:** Cambia el área de trabajo a la rama especificada, actualizando los archivos para reflejar el estado de esa rama.

**Ejemplo de uso:**
```bash
git checkout develop
git checkout main
git checkout feature/autenticacion
```

### `git checkout -b [rama]` - Crear y cambiar a una nueva rama

**Descripción:** Atajo conveniente que crea una nueva rama y cambia a ella en un solo comando.

**Ejemplo de uso:**
```bash
# Equivalente a: git branch feature/pagos && git checkout feature/pagos
git checkout -b feature/pagos
```

---

## 5. Fusionar Ramas

Una vez terminas el trabajo en una rama, necesitas fusionarla con otra (típicamente develop o main).

### `git merge [rama]` - Fusionar rama

**Descripción:** Integra los cambios de la rama especificada en la rama actual.

**Ejemplo de uso:**
```bash
# Primero asegúrate de estar en la rama destino
git checkout main

# Luego fusiona la rama feature
git merge feature/autenticacion

# Salida típica:
# Merge made by the 'recursive' strategy.
#  src/auth.js | 25 +++++++
#  1 file changed, 25 insertions(+)
```

**Nota:** Si hay conflictos (cambios incompatibles), Git te lo notificará y deberás resolverlos manualmente antes de completar el merge.

---

## 6. Historial de Cambios

Entender qué ha sucedido en el proyecto es crucial para debugging y auditoría.

### `git log` - Ver historial de commits

**Descripción:** Muestra el historial completo de commits, ordenado desde el más reciente hasta el más antiguo.

**Ejemplo de uso:**
```bash
git log

# Salida típica:
# commit abc123def456 (HEAD -> main)
# Author: Juan Pérez <juan@example.com>
# Date:   Mon Apr 21 10:30:45 2026 +0200
#
#     Añadir validación en formulario
#
# commit xyz789abc123
# Author: María García <maria@example.com>
# Date:   Mon Apr 21 08:15:20 2026 +0200
#
#     Refactor: simplificar lógica de autenticación
```

**Variantes útiles:**
```bash
# Mostrar commits en una línea
git log --oneline

# Ver últimos 5 commits
git log -5

# Ver con estadísticas
git log --stat

# Ver commits de un autor
git log --author="Juan"
```

### `git show [commit]` - Ver detalles de un commit

**Descripción:** Muestra información completa de un commit específico, incluyendo autor, fecha, mensaje y cambios realizados.

**Ejemplo de uso:**
```bash
git show abc123def
git show HEAD
git show HEAD~1  # El commit anterior
```

### `git show --name-only [commit]` - Archivos modificados en un commit

**Descripción:** Muestra solo los nombres de archivos que fueron modificados en un commit específico.

**Ejemplo de uso:**
```bash
git show --name-only abc123def

# Salida:
# commit abc123def456
# Author: Juan Pérez <juan@example.com>
# Date:   Mon Apr 21 10:30:45 2026 +0200
#
#     Añadir validación en formulario
#
# src/componentes/Form.jsx
# src/utilidades/validacion.js
# tests/validacion.test.js
```

### `git diff-tree --no-commit-id --name-only -r [commit]` - Lista de archivos por commit

**Descripción:** Similar a `show --name-only` pero en un formato más parseable, útil para scripts.

**Ejemplo de uso:**
```bash
git diff-tree --no-commit-id --name-only -r abc123def
```

### `git show [commit]` - Cambios línea por línea

**Descripción:** Cuando ejecutas `git show` sin opciones adicionales, muestra también las líneas exactas que fueron modificadas (añadidas o eliminadas).

**Ejemplo de uso:**
```bash
git show abc123def

# Muestra:
# + function validarEmail(email) {
# +   return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
# + }
# - function validar(email) {
# -   return email.includes('@');
# - }
```

---

## 7. Comparar Cambios

Es fundamental poder ver qué ha cambiado antes de preparar o confirmar cambios.

### `git diff` - Ver diferencias no preparadas

**Descripción:** Muestra las diferencias entre archivos modificados y la versión en el último commit, solo para cambios que aún no han sido preparados (staged).

**Ejemplo de uso:**
```bash
git diff

# Salida típica:
# diff --git a/src/index.js b/src/index.js
# index abc123..def456 100644
# --- a/src/index.js
# +++ b/src/index.js
# @@ -10,6 +10,7 @@
#  function main() {
# +  console.log('Iniciando aplicación');
#   initializeApp();
#  }
```

**Variantes útiles:**
```bash
# Ver diferencias incluidas las preparadas
git diff HEAD

# Ver diferencias de archivos preparados
git diff --staged

# Comparar dos ramas
git diff main..feature/auth

# Diferencias en líneas agregadas/eliminadas
git diff --stat
```

---

## 8. Control Remoto

El trabajo colaborativo requiere sincronización con repositorios remotos.

### `git remote -v` - Ver repositorios remotos

**Descripción:** Muestra todos los repositorios remotos configurados y sus URLs.

**Ejemplo de uso:**
```bash
git remote -v

# Salida típica:
# origin  https://github.com/usuario/proyecto.git (fetch)
# origin  https://github.com/usuario/proyecto.git (push)
# upstream https://github.com/original/proyecto.git (fetch)
# upstream https://github.com/original/proyecto.git (push)
```

### `git remote set-url origin [URL]` - Cambiar URL remota

**Descripción:** Actualiza la URL del repositorio remoto, útil cuando se migra a un nuevo servidor o cambias de proveedor.

**Ejemplo de uso:**
```bash
# Cambiar de HTTP a SSH
git remote set-url origin git@github.com:usuario/proyecto.git

# Cambiar de un proveedor a otro
git remote set-url origin https://gitlab.com/usuario/proyecto.git
```

### `git fetch` - Descargar cambios sin fusionar

**Descripción:** Descarga todos los cambios del repositorio remoto pero no los fusiona automáticamente. Útil para ver qué ha sucedido sin afectar tu trabajo local.

**Ejemplo de uso:**
```bash
git fetch origin
git fetch origin main
```

Después de fetch, puedes revisar los cambios antes de decidir si fusionarlos:
```bash
git log origin/main --oneline
```

### `git fetch origin "+refs/heads/*:refs/remotes/origin/*"` - Forzar actualización de ramas

**Descripción:** Realiza un fetch más agresivo que actualiza todas las ramas remotas, incluso si localmente tienen cambios incompatibles.

**Ejemplo de uso:**
```bash
# Útil cuando el servidor remoto ha eliminado o renombrado ramas
git fetch origin "+refs/heads/*:refs/remotes/origin/*"
```

### `git pull` - Descargar y fusionar cambios

**Descripción:** Combina `git fetch` y `git merge` en un solo comando. Descarga cambios del remoto y automáticamente los fusiona en tu rama actual.

**Ejemplo de uso:**
```bash
git pull origin main
git pull  # Si la rama local rastrca una remota
```

### `git push` - Enviar cambios al remoto

**Descripción:** Sube tus commits locales al repositorio remoto, haciendo que tus cambios estén disponibles para otros colaboradores.

**Ejemplo de uso:**
```bash
git push origin main
git push origin feature/auth
git push  # Si la rama local rastrca una remota
```

---

## 9. Deshacer Cambios y Recuperación

A veces necesitas deshacer cambios. Git ofrece varias opciones dependiendo de qué tan adelante estés en el proceso.

### `git reset [archivo]` - Quitar archivo del staging

**Descripción:** Elimina un archivo específico del área de preparación (staging), manteniendo los cambios en tu directorio de trabajo.

**Ejemplo de uso:**
```bash
git add .
git reset archivo-sensible.env  # Sacarlo del staging
git commit -m "Cambios sin archivo sensible"
```

### `git reset --hard` - Revertir al último commit

**Descripción:** Revierte tu repositorio al estado del último commit, eliminando TODOS los cambios locales no confirmados. ⚠️ Esta operación es destructiva.

**Ejemplo de uso:**
```bash
# Deshacer todos los cambios locales
git reset --hard

# Revertir a un commit específico (más peligroso)
git reset --hard abc123def
```

⚠️ **Advertencia:** `git reset --hard` es irreversible. Asegúrate de realmente querer descartar cambios.

### `git rm [archivo]` - Eliminar archivo del repositorio

**Descripción:** Elimina un archivo del repositorio y del sistema de archivos. Requiere commit para hacer efectivo.

**Ejemplo de uso:**
```bash
git rm archivo-obsoleto.js
git commit -m "Eliminar archivo obsoleto"
```

### `git rm -r --cached [carpeta]` - Dejar de rastrear sin eliminar

**Descripción:** Quita un archivo o carpeta del registro de Git sin eliminarlo del sistema de archivos. Útil para archivos que no debieron haber sido versionados (como `node_modules`, `.env`, etc.).

**Ejemplo de uso:**
```bash
# Dejar de rastrear carpeta de dependencias
git rm -r --cached node_modules
echo "node_modules/" >> .gitignore
git commit -m "Dejar de rastrear node_modules"
```

---

## 10. Gestión de Cambios Temporales

A veces necesitas cambiar de rama sin confirmar tus cambios actuales.

### `git stash` - Guardar cambios temporalmente

**Descripción:** Guarda todos los cambios no confirmados en un área temporal (stash), dejando tu directorio de trabajo limpio.

**Ejemplo de uso:**
```bash
# Tienes cambios sin confirmar pero necesitas cambiar de rama
git stash

# Ahora puedes cambiar de rama sin problemas
git checkout hotfix/bug-critico

# Cuando vuelvas, recuperas tus cambios
git checkout feature/auth
git stash pop
```

### `git stash pop` - Recuperar cambios guardados

**Descripción:** Restaura los cambios más recientes guardados en stash y los elimina del stash.

**Ejemplo de uso:**
```bash
git stash pop
```

**Variantes:**
```bash
# Ver todos los stash guardados
git stash list

# Aplicar un stash específico sin eliminarlo
git stash apply stash@{0}

# Eliminar un stash específico
git stash drop stash@{0}
```

---

## 11. Etiquetas para Releases

Las etiquetas marcan puntos importantes en el historial, típicamente para versiones de release.

### `git tag` - Listar etiquetas

**Descripción:** Muestra todas las etiquetas (tags) existentes en el repositorio.

**Ejemplo de uso:**
```bash
git tag

# Salida típica:
# v1.0.0
# v1.1.0
# v2.0.0
```

### `git tag [nombre]` - Crear una etiqueta

**Descripción:** Crea una etiqueta en el commit actual, útil para marcar versiones de release.

**Ejemplo de uso:**
```bash
# Crear etiqueta ligera
git tag v1.0.0

# Crear etiqueta anotada (con más metadatos)
git tag -a v1.0.0 -m "Versión 1.0.0 - Primera release"

# Crear etiqueta en un commit específico
git tag v1.0.0 abc123def
```

---

## 12. Reescritura de Historial

Para mantener un historial limpio, a veces es necesario reorganizar o consolidar commits.

### `git rebase` - Reorganizar commits

**Descripción:** Reaplica commits sobre otra base (rama), útil para mantener un historial lineal y limpio antes de fusionar.

**Ejemplo de uso:**
```bash
# Actualizar rama feature con cambios de main
git checkout feature/auth
git rebase main

# Rebase interactivo para reorganizar commits
git rebase -i HEAD~3  # Reorganizar últimos 3 commits
```

El rebase es especialmente útil en flujos de trabajo basados en pull requests, donde quieres que el historial sea lineal y fácil de seguir.

---

## Flujo de Trabajo Recomendado: Git Flow

Ahora que conoces los comandos individuales, veamos cómo se usan juntos en un flujo de trabajo profesional:

```bash
# 1. Clonar o inicializar el repositorio
git clone https://github.com/equipo/proyecto.git
cd proyecto

# 2. Crear rama de feature
git checkout -b feature/nueva-funcionalidad

# 3. Trabajar en la funcionalidad
# ... editar archivos ...

# 4. Verificar cambios
git status
git diff

# 5. Preparar y confirmar cambios
git add .
git commit -m "Implementar nueva funcionalidad"

# 6. Actualizar con cambios del equipo
git pull origin develop

# 7. Si hay conflictos, resolverlos y continuar
git add .
git commit -m "Resolver conflictos de merge"

# 8. Enviar rama al repositorio remoto
git push origin feature/nueva-funcionalidad

# 9. En GitHub/GitLab, crear Pull Request
# ... revisar código ...
# ... aprobar ...

# 10. Fusionar en develop
git checkout develop
git pull origin develop
git merge feature/nueva-funcionalidad

# 11. Eliminar rama local si ya no la necesitas
git branch -d feature/nueva-funcionalidad

# 12. Mantener sincronizado
git pull origin develop
```

---

## Mejores Prácticas

### ✅ Haz:

1. **Commits pequeños y enfocados:** Cada commit debe representar un cambio lógico individual. Facilita el review y el debugging.

2. **Mensajes descriptivos:** "Añadir validación" es mejor que "Cambios". "Refactor: separar lógica de autenticación en módulo" es excelente.

3. **Usar ramas para features:** Nunca desarrolles directamente en `main`. Usa ramas específicas para cada feature o bug.

4. **Pull antes de push:** Siempre actualiza tu rama local con `git pull` antes de hacer `git push` para evitar conflictos.

5. **Revisar código:** Usa pull requests para que otros desarrolladores revisen tu código antes de fusionar.

### ❌ No hagas:

1. **Commits enormes:** Cambios de 500+ líneas sin contexto son difíciles de revisar.

2. **Usar `--force` sin razón:** `git push --force` puede sobrescribir el trabajo de otros. Úsalo solo en casos especiales.

3. **Trabajar directamente en main:** Siempre usa ramas. La rama main debe estar siempre en estado deployment.

4. **Ignorar conflictos de merge:** Entiende qué causó el conflicto y resuélvelo correctamente, no simplemente aceptes un lado.

5. **Pushear secretos o credenciales:** Nunca haga commit de `.env`, tokens, o contraseñas. Usa `.gitignore`.

---

## Conclusión

Git es una herramienta poderosa que, una vez dominada, se convierte en tu mejor aliado en el desarrollo de software. Los comandos que hemos cubierto en este artículo representan el 95% de lo que necesitarás en tu día a día como desarrollador.

Recuerda que:
- **La práctica hace al maestro:** Usa Git en todos tus proyectos, incluso personales.
- **Lee documentación oficial:** El manual de Git es excelente: `git help comando`
- **Experimenta en seguridad:** Crea repositorios de prueba para practicar operaciones arriesgadas.
- **El historial es tu amigo:** Gracias a Git, nunca pierdes trabajo; siempre puedes recuperar cambios antiguos.

Con estos comandos y estas mejores prácticas, estarás preparado para colaborar eficientemente en equipos de desarrollo, mantener proyectos bien organizados, y responder rápidamente cuando algo sale mal.

¡Ahora es momento de practicar! Abre tu terminal y comienza a usar Git en tu próximo proyecto.

---

## Referencias y Recursos Adicionales

- [Documentación oficial de Git](https://git-scm.com/doc)
- [Pro Git Book (Gratis en línea)](https://git-scm.com/book/es/v2)
- [GitHub Learning Lab](https://lab.github.com/)
- [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
- [Oh Shit, Git!?!](https://ohshitgit.com/) - Recuperación de desastres comunes con Git
