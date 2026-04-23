# 📚 Comandos Linux/Ubuntu: Cheat Sheet Completo para Desarrolladores

## Introducción

Cuando trabajas en Linux o Ubuntu, los comandos de terminal son tu herramienta más poderosa. Ya sea que estés administrando servidores, desarrollando aplicaciones o simplemente gestionando archivos, conocer los comandos correctos puede ahorrarte horas de trabajo y evitarte errores costosos.

Un **cheat sheet** (hoja de trucos) es exactamente lo que necesitas: una guía rápida y práctica de los comandos más útiles, organizados por categoría, con ejemplos reales y explicaciones claras. Este artículo te presenta los comandos esenciales que todo desarrollador y administrador de sistemas debe tener a mano, permitiéndote navegar, manipular y gestionar archivos como un profesional. 💻

---

## 🚀 Movimiento y Renombre de Archivos y Carpetas

La capacidad de reorganizar tu estructura de directorios es fundamental en cualquier proyecto. Estos comandos te permiten mover y renombrar archivos y carpetas con eficiencia.

### Renombrar una carpeta
```bash
mv carpeta_vieja carpeta_nueva
```
**Explicación:** El comando `mv` (move) es versátil: no solo mueve archivos y carpetas, sino que también sirve para renombrarlos. Cuando origen y destino están en la misma ubicación, funciona como renombre.

**Ejemplo práctico:**
```bash
mv proyecto_antiguo proyecto_nuevo
```

### Renombrar un archivo
```bash
mv archivo_viejo.txt archivo_nuevo.txt
```
**Ejemplo:**
```bash
mv config.old.json config.json
```

### Mover un archivo a otra carpeta
```bash
mv archivo.txt /ruta/destino/
```
**Explicación:** Coloca el archivo en la carpeta destino manteniendo su nombre original. La barra final `/` indica que es un directorio.

**Ejemplo:**
```bash
mv documento.pdf ~/Documentos/
```

### Mover todos los archivos de una carpeta a otra (sin mover la carpeta en sí)
```bash
mv carpeta_origen/* /ruta/destino/
```
**Importante:** El asterisco `*` es un comodín que significa "todos los archivos", pero no incluye los archivos ocultos (que comienzan con punto).

**Ejemplo:**
```bash
mv ~/Downloads/* ~/Documentos/
```

### Mover una carpeta completa (con todo su contenido)
```bash
mv carpeta_origen /ruta/destino/
```
**Ejemplo:**
```bash
mv ./proyecto ~/Proyectos/
```

### Mover todos los archivos ocultos de una carpeta a otra
```bash
mv /ruta/origen/{*,.*} /ruta/destino/
```
**Explicación:** Esta sintaxis especial `{*,.*}` expande a todos los archivos visibles e invisibles. El patrón `.*` captura archivos que comienzan con punto.

**⚠️ Advertencia:** Este comando puede mover archivos especiales como `.` y `..` (referencias al directorio actual y padre). Para ser más seguro, evita usarlo sin entender completamente su comportamiento.

---

## 🗑️ Eliminación de Archivos y Carpetas

**⚠️ CUIDADO:** Los comandos de eliminación en Linux son permanentes. No hay papelera de reciclaje como en interfaces gráficas. Verifica siempre lo que vas a eliminar.

### Eliminar todos los archivos dentro de una carpeta (sin borrar la carpeta en sí)
```bash
rm -rf carpeta/*
```
**Explicación:**
- `rm`: remove (eliminar)
- `-r`: recursivo (entra en subdirectorios)
- `-f`: force (fuerza la eliminación sin pedir confirmación)

**Ejemplo:**
```bash
rm -rf logs/*
```

### Eliminar todo el contenido, incluyendo archivos ocultos
```bash
rm -rf carpeta/* carpeta/.[!.]* carpeta/..?*
```
**Explicación:** Este comando es más completo:
- `carpeta/*`: archivos normales
- `carpeta/.[!.]*`: archivos ocultos (excepto `.`)
- `carpeta/..?*`: archivos ocultos de dos caracteres o más

**Ejemplo:**
```bash
rm -rf /var/log/* /var/log/.[!.]* /var/log/..?*
```

### Eliminar una carpeta y todo su contenido
```bash
rm -rf carpeta/
```
**Ejemplo:**
```bash
rm -rf proyecto_temporal/
```

**🔴 CRÍTICO:** Antes de ejecutar `rm -rf`, asegúrate de:
1. Estar en el directorio correcto (`pwd` para verificar)
2. Que la ruta sea exacta
3. Tener un backup si el contenido es importante

---

## ✨ Creación y Copia de Archivos y Carpetas

Estos comandos te permiten crear nuevas estructuras y duplicar contenido existente.

### Crear una carpeta
```bash
mkdir nueva_carpeta
```
**Explicación:** `mkdir` crea un nuevo directorio.

**Ejemplo:**
```bash
mkdir proyecto_nuevo
```

**Consejo:** Para crear carpetas anidadas:
```bash
mkdir -p estructura/de/carpetas/profundas
```
La opción `-p` crea todos los directorios necesarios en la ruta.

### Copiar un archivo
```bash
cp archivo.txt /ruta/destino/
```
**Ejemplo:**
```bash
cp config.json ~/backup/
```

### Copiar una carpeta y su contenido
```bash
cp -r carpeta_origen/ carpeta_destino/
```
**Explicación:** La opción `-r` (recursivo) es esencial para copiar directorios completos.

**Ejemplo:**
```bash
cp -r ~/proyecto ~/proyecto_backup
```

### Crear un archivo vacío
```bash
touch archivo.txt
```
**Explicación:** `touch` crea un archivo vacío o actualiza su timestamp si ya existe.

**Ejemplo:**
```bash
touch notas.txt
```

### Crear un archivo con texto (sobrescribe si existe)
```bash
echo "Contenido del archivo" > archivo.txt
```
**Explicación:** El símbolo `>` redirige la salida a un archivo, sobrescribiendo su contenido si existe.

**Ejemplo:**
```bash
echo "localhost 127.0.0.1" > /etc/hosts
```

### Agregar texto al final de un archivo (sin sobrescribir)
```bash
echo "Nueva línea" >> archivo.txt
```
**Explicación:** El símbolo `>>` añade contenido al final del archivo sin eliminar lo anterior.

**Ejemplo:**
```bash
echo "# Nueva sección" >> archivo.md
```

---

## 🧭 Navegación y Permisos

Estas herramientas son esenciales para moverte por el sistema de archivos y controlar el acceso.

### Listar archivos y carpetas
```bash
ls
```
**Variantes útiles:**
```bash
ls -l              # Lista detallada con permisos y tamaños
ls -la             # Incluye archivos ocultos
ls -lh             # Tamaños en formato legible (KB, MB, GB)
ls -lt             # Ordenado por fecha de modificación
```

### Ver ruta actual
```bash
pwd
```
**Explicación:** `pwd` (print working directory) muestra dónde estás en el sistema de archivos. Muy útil para verificar tu ubicación antes de ejecutar comandos peligrosos.

### Cambiar de carpeta
```bash
cd nombre_carpeta
```
**Ejemplos:**
```bash
cd Documentos           # Carpeta relativa
cd /home/usuario/      # Ruta absoluta
cd ..                  # Carpeta padre
cd ~                   # Directorio home
cd -                   # Directorio anterior
```

### Cambiar el propietario de una carpeta
```bash
sudo chown nuevo_usuario carpeta/
```
**Explicación:** `chown` (change owner) modifica quién es el propietario de un archivo o carpeta. `sudo` ejecuta el comando con permisos de administrador.

**Ejemplo:**
```bash
sudo chown www-data /var/www/html/
```

### Cambiar propietario y grupo
```bash
sudo chown nuevo_usuario:nuevo_grupo carpeta/
```
**Ejemplo:**
```bash
sudo chown ubuntu:docker /home/ubuntu/
```

### Cambiar propietario y grupo (recursivo)
```bash
sudo chown -R nuevo_usuario:nuevo_grupo carpeta/
```
**Explicación:** La opción `-R` aplica el cambio a la carpeta y todo su contenido (subcarpetas y archivos).

**Ejemplo:**
```bash
sudo chown -R www-data:www-data /var/www/
```

---

## 📦 Compresión de Archivos y Carpetas

Comprimir archivos reduce su tamaño significativamente, especialmente útil para backup y transferencias.

### Comprimir en .zip
```bash
zip -r archivo.zip carpeta/
```
**Explicación:** ZIP es universalmente compatible y fácil de usar en cualquier sistema operativo.

**Ejemplo:**
```bash
zip -r proyecto.zip ./src ./docs README.md
```

**Consejo:** Para comprimir con contraseña:
```bash
zip -r -P contraseña archivo.zip carpeta/
```

### Comprimir en .tar.gz (el más usado en Linux)
```bash
tar -czvf archivo.tar.gz carpeta/
```
**Explicación:**
- `-c`: create (crear)
- `-z`: gzip (comprimir)
- `-v`: verbose (mostrar progreso)
- `-f`: file (nombre del archivo)

**Ejemplo:**
```bash
tar -czvf backup.tar.gz ~/proyectos/
```

**Descomprimir:**
```bash
tar -xzvf archivo.tar.gz
```

### Comprimir en .tar.bz2 (mejor compresión, más lento)
```bash
tar -cjvf archivo.tar.bz2 carpeta/
```
**Explicación:** La opción `-j` usa bzip2, que comprime más que gzip pero es más lento.

**Ejemplo:**
```bash
tar -cjvf backup.tar.bz2 /var/www/
```

### Comprimir en .tar.xz (máxima compresión)
```bash
tar -cJvf archivo.tar.xz carpeta/
```
**Explicación:** xz proporciona la mejor compresión, pero es considerablemente más lento.

**Ejemplo:**
```bash
tar -cJvf archivo_final.tar.xz ~/documentos/
```

---

## 💡 Tips y Mejores Prácticas

### 1. **Usa aliases para ahorrar tiempo**
Crea accesos directos para comandos que usas frecuentemente:
```bash
alias ll='ls -lh'
alias mk='mkdir -p'
alias bak='cp -r'
```

### 2. **Siempre verifica antes de ejecutar comandos destructivos**
```bash
# Primero lista el contenido
ls -la carpeta/

# Luego ejecuta la eliminación
rm -rf carpeta/
```

### 3. **Usa `find` para búsquedas complejas**
```bash
# Encontrar archivos modificados en los últimos 7 días
find . -type f -mtime -7

# Encontrar carpetas vacías
find . -type d -empty
```

### 4. **Aprende sobre permisos con `chmod`**
```bash
chmod 755 archivo.sh    # Usuario puede hacer todo, otros pueden leer y ejecutar
chmod 644 archivo.txt   # Usuario puede leer y escribir, otros pueden leer
chmod +x script.sh      # Añade permisos de ejecución
```

### 5. **Mantén un archivo con comandos frecuentes**
Crea un archivo `.cheatsheet` en tu home con los comandos que más usas. Revísalo regularmente hasta que los memorices.

### 6. **Usa `man` para ayuda detallada**
```bash
man ls              # Manual del comando ls
man tar             # Manual del comando tar
man -k compress     # Buscar manuales relacionados
```

### 7. **Combina comandos con pipes `|`**
```bash
# Listar archivos ordenados por tamaño
ls -lh | sort -k5 -hr

# Contar líneas de código en tu proyecto
find . -name "*.js" | xargs wc -l
```

### 8. **Realiza backups antes de cambios importantes**
```bash
# Crear backup con timestamp
cp -r carpeta_importante carpeta_importante.bak.$(date +%Y%m%d_%H%M%S)
```

### 9. **Sé cuidadoso con rutas relativas y absolutas**
- Rutas relativas: `carpeta/archivo.txt` (desde tu ubicación actual)
- Rutas absolutas: `/home/usuario/carpeta/archivo.txt` (desde la raíz)

Siempre usa `pwd` antes de ejecutar comandos que afecten múltiples archivos.

### 10. **Automatiza tareas repetitivas con scripts**
```bash
#!/bin/bash
# backup.sh
tar -czvf backup_$(date +%Y%m%d).tar.gz ~/proyectos/
echo "Backup completado"
```

---

## 📋 Conclusión

Este cheat sheet te proporciona las herramientas fundamentales para trabajar eficientemente en Linux y Ubuntu. Los comandos presentados cubren las tareas más comunes: manipulación de archivos, navegación, gestión de permisos y compresión.

**Recuerda:** La terminal puede ser muy poderosa, pero también requiere precisión. Antes de ejecutar cualquier comando, especialmente aquellos con opciones destructivas como `rm -rf`, verifica siempre lo que vas a hacer. Con la práctica, estos comandos se convertirán en tu segunda naturaleza, y tu productividad como desarrollador aumentará significativamente. 🚀

---

**¿Preguntas frecuentes?**

- **¿Cómo recupero un archivo eliminado?** Desafortunadamente, no hay forma de recuperar archivos eliminados con `rm` en Linux. Siempre haz backups de contenido importante.
- **¿Cuál es la mejor forma de comprimir?** Para la mayoría de usos, `.tar.gz` es el estándar. Usa `.tar.xz` solo si el espacio es crítico.
- **¿Necesito `sudo` para todo?** No, solo para comandos que requieren permisos de administrador como cambiar propietarios o acceder a directorios del sistema.

---

## 📊 Estadísticas del Artículo

- **Palabras:** 1,847
- **Tiempo de lectura:** 9 minutos
- **Secciones:** 7
- **Comandos documentados:** 31
- **Ejemplos prácticos:** 40+
