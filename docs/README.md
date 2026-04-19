# Documentación - Proyecto Blog TechDaily

Bienvenido a la documentación del Blog TechDaily. Aquí encontrarás toda la información necesaria para entender, desarrollar y mantener el proyecto.

## 🚀 Inicio Rápido

**¿Tienes 15 minutos?** → Lee [`START_HERE.md`](START_HERE.md)

**¿Necesitas entender todo?** → Lee [`RESUMEN_EJECUTIVO.md`](RESUMEN_EJECUTIVO.md)

## 📚 Documentos Disponibles

### Análisis y Arquitectura

| Documento | Contenido | Tiempo |
|-----------|----------|--------|
| **[START_HERE.md](START_HERE.md)** | Guía de inicio rápido | 15 min |
| **[RESUMEN_EJECUTIVO.md](RESUMEN_EJECUTIVO.md)** | Visión general del proyecto | 20 min |
| **[ANALISIS_DETALLADO.md](ANALISIS_DETALLADO.md)** | Análisis técnico completo (1400+ líneas) | 60+ min |
| **[ARQUITECTURA_DIAGRAMAS.md](ARQUITECTURA_DIAGRAMAS.md)** | Diagramas de flujo, ERD, capas | 30 min |
| **[INDICE_ANALISIS.md](INDICE_ANALISIS.md)** | Índice completo de toda la documentación | 10 min |
| **[SETTINGS_FIX_SUMMARY.md](SETTINGS_FIX_SUMMARY.md)** | Documento de fix específico | 5 min |

### Guías de Deployment

Para documentación sobre deployment, Docker y configuración, ver carpeta `/docs/deployment/`:

- **[DEPLOYMENT_GUIDE.md](deployment/DEPLOYMENT_GUIDE.md)** - Guía completa de deployment
- **[docker-guide.md](deployment/docker-guide.md)** - Guía de Docker y contenedores
- **[environment-config.md](deployment/environment-config.md)** - Configuración de entorno
- **[virtual-hosts.md](deployment/virtual-hosts.md)** - Configuración de virtual hosts

## 🎯 ¿Qué Buscas?

### "Quiero empezar en 15 minutos"
→ Lee: [START_HERE.md](START_HERE.md)

### "Necesito entender la arquitectura"
→ Lee: [ARQUITECTURA_DIAGRAMAS.md](ARQUITECTURA_DIAGRAMAS.md)

### "Quiero detalles técnicos completos"
→ Lee: [ANALISIS_DETALLADO.md](ANALISIS_DETALLADO.md)

### "Necesito saber qué existe en el proyecto"
→ Lee: [RESUMEN_EJECUTIVO.md](RESUMEN_EJECUTIVO.md)

### "Necesito hacer deployment"
→ Lee: [deployment/DEPLOYMENT_GUIDE.md](deployment/DEPLOYMENT_GUIDE.md)

### "¿Dónde está todo? Necesito un índice"
→ Lee: [INDICE_ANALISIS.md](INDICE_ANALISIS.md)

## 🛠️ Stack Tecnológico

### Frontend
- **React 18.3.1** + TypeScript 5.5.3
- **Vite 5.4.2** como bundler
- **Tailwind CSS 3.4.1** para estilos
- **PWA completa** instalable como app

### Backend
- **Laravel 13.0** framework
- **PHP 8.4** lenguaje
- **Filament 4.0** admin panel
- **MySQL 8.x** base de datos
- **Laravel Sanctum** autenticación API

## 📊 Estructura del Proyecto

```
blog/
├── frontend/              # Aplicación React + TypeScript
├── backend/              # API Laravel 13 + Filament
├── .opencode/            # Configuración de agentes IA
│   ├── agents/           # Definiciones de 5 agentes
│   ├── workitems/        # Tareas a implementar
│   └── docs/             # Documentación interna
├── docs/                 # ← ESTÁS AQUÍ (documentación pública)
│   ├── deployment/       # Guías de deployment
│   ├── START_HERE.md
│   ├── RESUMEN_EJECUTIVO.md
│   ├── ANALISIS_DETALLADO.md
│   ├── ARQUITECTURA_DIAGRAMAS.md
│   ├── INDICE_ANALISIS.md
│   └── README.md         # Este archivo
└── README.md             # Raíz del proyecto
```

## 🔄 Flujos Principales

### Desarrollo Local

```bash
# Frontend (Vite dev server)
cd frontend
npm install
npm run dev
# → http://localhost:5173

# Backend (Docker)
docker exec docker_php84 bash
cd /var/www/html/blog/backend
php artisan migrate
php artisan db:seed
# → http://blog-api.local/api
```

### Base de Datos

```
Host: docker_mysql:3306 (local: localhost:3306)
Usuario: root
Contraseña: toor
Base de datos: techdaily
```

## 📖 Orden de Lectura Recomendado

1. **Nivel Principiante** (30 min total)
   - START_HERE.md (15 min)
   - RESUMEN_EJECUTIVO.md (15 min)

2. **Nivel Intermedio** (90 min total)
   - Anterior + ARQUITECTURA_DIAGRAMAS.md (30 min)
   - + ANALISIS_DETALLADO.md (30 min)

3. **Nivel Experto** (120+ min total)
   - Todo lo anterior
   - + Documentación de .opencode/agents/
   - + Documentación de deployment/

## 🤖 Sistema de Agentes IA

El proyecto incluye un sistema de 5 agentes IA coordinados:

1. **Tech Lead** - Coordinador y arquitecto
2. **Backend Laravel 12** - Especialista PHP/Laravel
3. **Frontend Integration** - Especialista React/TypeScript
4. **Code Review** - Validador de calidad
5. **Dev Fullstack** - Ejecutor fullstack

Para más información sobre los agentes, ver: `.opencode/agents/README.md`

## 📋 Workitems y Tareas

Las tareas a implementar están en `.opencode/workitems/`:

- `fix-user-is-admin-field.md` - Arreglar campo is_admin en User
- `fix-user-password-confirmation.md` - Agregar confirmación de password
- `fix-author-avatar-required.md` - Hacer avatar nullable en Author

Enviar estas tareas al **Tech Lead** para que delegue a los agentes correspondientes.

## 🔗 Enlaces Rápidos

### Documentación Interna
- [.opencode/AGENT_TECH_LEAD.md](../.opencode/AGENT_TECH_LEAD.md) - Guía completa Tech Lead
- [.opencode/AGENT_DEV_FULLSTACK.md](../.opencode/AGENT_DEV_FULLSTACK.md) - Guía completa Dev Fullstack
- [.opencode/INTEGRACION_EQUIPO.md](../.opencode/INTEGRACION_EQUIPO.md) - Cómo trabajan juntos los agentes
- [.opencode/agents/README.md](../.opencode/agents/README.md) - Índice de 5 agentes

### Código del Proyecto
- Frontend: `./frontend/` - React 18, TypeScript, Vite
- Backend: `./backend/` - Laravel 13, Filament, MySQL
- Admin Panel: `http://blog-api.local/admin` (en desarrollo local)

## 📞 Soporte

### ¿Necesitas encontrar algo específico?

1. **Búsqueda rápida:** Usa Ctrl+F en cualquier documento
2. **Índice completo:** Lee [INDICE_ANALISIS.md](INDICE_ANALISIS.md)
3. **Documentación técnica:** Lee [ANALISIS_DETALLADO.md](ANALISIS_DETALLADO.md)
4. **Diagramas:** Lee [ARQUITECTURA_DIAGRAMAS.md](ARQUITECTURA_DIAGRAMAS.md)

## 🎓 Aprendizaje Progresivo

### Semana 1: Entender el Proyecto
- Leer START_HERE.md
- Entender la arquitectura (ARQUITECTURA_DIAGRAMAS.md)
- Ejecutar comandos de desarrollo

### Semana 2: Profundizar
- Leer ANALISIS_DETALLADO.md
- Explorar el código en frontend/ y backend/
- Hacer cambios pequeños

### Semana 3+: Mastery
- Entender el sistema de agentes
- Colaborar en features
- Mentorizar a otros

## 📝 Versión y Fecha

- **Versión del Proyecto:** Blog TechDaily
- **Versión de Documentación:** 1.0
- **Fecha de Actualización:** 19 de Abril de 2026
- **Última Modificación:** 19 de Abril de 2026

## 🔐 Notas de Seguridad

- No guardes credenciales en código
- Las variables `.env` no se suben al repositorio
- Usa variables de entorno para configuración sensible
- En producción, cambiar todas las contraseñas por defecto

## 📈 Próximos Pasos

1. **Lee** un documento según tu necesidad (arriba)
2. **Entiende** la estructura del proyecto
3. **Configura** tu entorno de desarrollo
4. **Comienza** a trabajar con los agentes IA

---

**¿Listo para comenzar? Abre [START_HERE.md](START_HERE.md) →**
