---
title: "IA en equipos de desarrollo: luces, sombras y responsabilidad"
slug: ia-en-equipos-de-desarrollo-luces-sombras-responsabilidad
summary: "La IA en el desarrollo de software trae ganancias reales de productividad, pero también patrones riesgosos: PRs masivos, delegación ciega y la frase que más me preocupa: 'la IA me lo dijo'."
main_image: "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200&h=800&fit=crop"
embedded_images:
  - "https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=500&fit=crop"
  - "https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=800&h=500&fit=crop"
  - "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&h=500&fit=crop"
author_name: "Developer Anónimo"
author_slug: "developer-anonimo"
tags:
  - IA
  - Desarrollo de Software
  - Buenas Prácticas
  - Code Review
  - Productividad
read_time: 12
---

# IA en equipos de desarrollo: luces, sombras y responsabilidad

> *Una mirada honesta desde las trincheras del código cotidiano*

---

Hace unos meses, en una reunión de equipo, escuché algo que me quedó resonando. Un compañero presentaba el diseño de una nueva arquitectura para un módulo crítico. Cuando alguien preguntó por qué había elegido ese enfoque en particular, la respuesta fue casi instantánea:

*"Porque Claude Code me lo recomendó."*

Silencio. Nadie dijo nada. Y eso, precisamente, fue lo que me pareció más preocupante.

No escribo esto para atacar las herramientas de IA ni a quienes las usan. Uso estas herramientas todos los días y me han salvado horas de trabajo repetitivo. Escribo esto porque creo que estamos en un momento bisagra donde podemos —si prestamos atención— establecer hábitos sanos alrededor de estas tecnologías antes de que los malos hábitos se vuelvan cultura.

---

## El entusiasmo de la dirección (y cómo filtra hacia el equipo)

Primero, el contexto. La empresa donde trabajo abrazó las herramientas de IA con entusiasmo genuino. Eso, en principio, está bien. La dirección no solo permite su uso: lo *incentiva*. Hay métricas de velocidad de entrega que mejorar, hay demostraciones internas de cómo Copilot puede generar boilerplate en segundos, hay celebraciones cuando un developer cierra cinco tickets en un día que antes le habría llevado tres.

Ese entusiasmo es comprensible. Según una [encuesta de GitHub (2024)](https://github.blog/news-insights/research/survey-ai-wave-grows/) que abarcó 2.000 profesionales de desarrollo en cuatro países, más del 97% de los encuestados reportaron haber usado herramientas de IA en su trabajo en algún momento. Y entre los beneficios más citados están la mejora en calidad de código, la aceleración del onboarding y el ahorro de tiempo para tareas más estratégicas. Los números respaldan el entusiasmo.

El problema no está en el entusiasmo. El problema está en lo que ocurre cuando el entusiasmo viaja hacia abajo en la jerarquía sin acompañarse de criterio.

---

## Las ventajas son reales: no nos hagamos los escépticos

Antes de entrar en los problemas, necesito ser honesto sobre algo: estas herramientas realmente funcionan para muchas cosas. Y negarlas sería tan irresponsable como abrazarlas sin criterio.

![Programador trabajando con asistencia de IA en pantalla dual](https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=500&fit=crop)

### Lo que la IA hace bien (muy bien)

**Generación de boilerplate y código repetitivo.** Configuraciones de proyectos, estructuras de archivos, migraciones de bases de datos con patrones estándar, implementaciones de interfaces conocidas. Para esto, las herramientas como GitHub Copilot o Claude Code son extraordinariamente útiles. Lo que antes tomaba media hora de tipeo mecánico ahora toma minutos.

**Exploración de APIs y documentación inline.** ¿Necesito usar una API que no conozco bien? La IA puede darme un primer ejemplo funcional en segundos. Es como tener a un compañero que ya leyó la documentación por mí, aunque —como con cualquier compañero— siempre conviene verificar.

**Refactoring de código existente.** "Convierte este switch/case en un patrón Strategy", "Extrae esta lógica en un servicio", "Añade manejo de errores a esta función". Para refactorings bien definidos y acotados, la IA es genuinamente poderosa.

**Debugging asistido.** Pegar un stack trace y obtener posibles causas en segundos ahorra tiempo real, especialmente con errores crípticos de frameworks que no dominas perfectamente.

**Tests unitarios para lógica pura.** Generar casos de prueba para funciones con entradas y salidas bien definidas es algo donde la IA brilla. Es una de las tareas más tediosas del desarrollo y la IA la democratiza.

**Documentación y comentarios.** Generar JSDoc, docstrings o comentarios explicativos para código existente. Honestamente, si la IA puede encargarse de esto, hay pocas razones para resistirse.

Dicho todo esto, ahora hablemos de lo que me quita el sueño.

---

## Las sombras del entusiasmo

### El Pull Request de 47 archivos

Hace algunas semanas llegó a revisión un PR. Lo abrí con el hábito habitual: mirar el título, revisar la descripción, ver cuántos archivos hay afectados.

47 archivos. 1.832 líneas añadidas. 654 eliminadas.

No era una refactorización masiva planeada ni una migración de framework. Era *una funcionalidad nueva*. Mediana. El tipo de cosa que en otro contexto habría sido 8-12 archivos, quizás.

Intenté revisarlo en serio. Duré cuarenta minutos antes de aceptar que era imposible hacer una revisión honesta. Los cambios saltaban de capa en capa: modelo, controlador, servicio, tests, migraciones, configuraciones, vistas, tipos. Todo mezclado. Todo generado de una sola pasada con la IA, probablemente con algo como "implementa el módulo de X".

![Vista de un diff extenso en GitHub con múltiples archivos cambiados](https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=800&h=500&fit=crop)

Esto no es un caso aislado. Es un patrón que veo cada vez con más frecuencia. El developer le describe a la IA la feature completa, la IA genera todo lo necesario de golpe, y el developer —convencido de que "funciona porque pasaron los tests"— abre el PR.

El problema es que el code review deja de existir como práctica de calidad y se convierte en una firma de aprobación con culpa compartida diluida. Nadie puede revisar 47 archivos en serio. Y eso significa que nadie realmente sabe qué hay ahí.

### La delegación ciega: desarrollo *y* testing

El escenario anterior tiene una variante aún más preocupante: la delegación total, incluyendo los tests.

"La IA escribió el código y la IA escribió los tests. Los tests pasan. ¿Listo?"

Hay algo profundamente circular en esto que no siempre es obvio a primera vista. Cuando el mismo agente que genera el código genera también sus pruebas, existe un riesgo real de que los tests validen exactamente lo que el código hace, no lo que el código *debería* hacer. Es la versión moderna de que el alumno se corrija su propio examen.

Un test bien escrito por un humano empieza con la pregunta: *¿qué comportamiento necesito garantizar?* Un test generado automáticamente a partir del código existente muchas veces empieza desde el código mismo y trabaja hacia atrás. Son ejercicios fundamentalmente diferentes.

Además, la IA no conoce el contexto de negocio. No sabe que ese campo "opcional" en el formulario en realidad es obligatorio para clientes enterprise. No sabe que esa función que parece simple tiene un edge case histórico que causó un incidente hace dos años. El conocimiento contextual del equipo humano es irreemplazable para construir tests que realmente protejan el sistema.

### "La IA me lo dijo": la transferencia de responsabilidad

Vuelvo al momento que describí al principio. Y quiero ser preciso sobre por qué me inquietó tanto.

No es que confiar en herramientas sea malo. Confiamos en linters, en compiladores, en analizadores estáticos. La diferencia es que cuando un compilador me dice que hay un error de tipos, entiendo *por qué* hay un error de tipos. Puedo razonar sobre ello.

La frase "la IA me lo recomendó" usada como justificación técnica final es una forma de eludir la responsabilidad del razonamiento. Es delegar no solo la *ejecución* de una tarea, sino el *criterio* detrás de ella.

¿Por qué elegiste esa arquitectura? *Porque la IA la recomendó.*
¿Por qué este approach de caching? *Porque la IA lo sugirió.*
¿Por qué esta dependencia externa? *Porque la IA dijo que era la mejor opción.*

La cuestión no es si la IA acertó o no en esas recomendaciones. Puede haber acertado perfectamente. La cuestión es que el developer —y por extensión el equipo— perdió la oportunidad de construir comprensión sobre el sistema que están construyendo.

Y cuando algo falla a las 2 AM, la IA no va a estar disponible para asumir consecuencias. El equipo, sí.

### La deuda técnica silenciosa

Hay otro fenómeno que aún no tiene nombre claro pero que ya reconozco cuando lo veo: código que *funciona* pero que nadie del equipo entiende realmente.

El código generado por IA es frecuentemente correcto en lo inmediato pero opaco en su lógica interna. No porque la IA escriba mal —a veces escribe mejor que nosotros— sino porque fue generado sin el proceso de razonamiento que hace que el autor de un código pueda explicarlo, defenderlo y modificarlo con confianza.

El resultado es código huérfano de comprensión. Pasa los tests. Llega a producción. Y seis meses después, cuando hay que modificarlo, nadie sabe bien cómo funciona ni por qué está escrito así. La deuda técnica no siempre es código malo. A veces es código que nadie entiende.

---

## Recaudos y buenas prácticas: lo que el equipo puede hacer hoy

No propongo abandonar las herramientas. Propongo usarlas con la misma disciplina con que usamos cualquier otra herramienta poderosa.

![Dashboard de métricas de code review y pull requests](https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&h=500&fit=crop)

### 1. Los PRs pequeños siguen siendo un estándar de calidad

Esto no es nuevo. La regla de oro de los PRs manejables —máximo 200-400 líneas, cambios cohesivos, un propósito claro— existe por buenas razones que no cambian porque ahora generemos código más rápido.

Si la IA te ayuda a desarrollar más velozmente, eso no justifica acumular todo en un PR gigante. Al contrario: debería permitirte hacer PRs más frecuentes y más pequeños. Un PR de 47 archivos que llegó en un día es una señal de que el proceso se rompió, no de que el developer fue más productivo.

**Regla práctica:** Si tu PR tiene más de 300 líneas de código nuevo (no contando tests), pregúntate si puede dividirse. En casi todos los casos, puede.

### 2. La arquitectura es responsabilidad humana, no del modelo

Las decisiones de arquitectura tienen contexto de negocio, historia técnica, conocimiento de los constraints reales del sistema, consideraciones de equipo. Un modelo de lenguaje no tiene acceso a nada de eso, o tiene acceso solo a lo que le describiste en el prompt —que suele ser una fracción de la realidad.

Usa la IA para explorar opciones, para ver trade-offs, para buscar patrones. Pero la decisión final, y la justificación de esa decisión, debe vivir en la cabeza de alguien del equipo. Alguien que pueda defenderla en una retrospectiva, explicarla a un nuevo miembro o reconsiderarla cuando cambia el contexto.

**Regla práctica:** Si no puedes explicar con tus propias palabras *por qué* tomaste una decisión de diseño, no la tomes todavía.

### 3. El code review debe adaptarse, no rendirse

La cultura de revisión de código necesita evolucionar para este contexto. Si los PRs son más grandes porque la generación es más rápida, la respuesta no es resignarse a revisiones superficiales. La respuesta es:

- Establecer acuerdos explícitos de tamaño máximo de PR
- Pedir que los PRs generados con IA incluyan descripción de *qué* se decidió y *por qué*
- Distinguir revisión de lógica (la parte crítica) de revisión de estilo (donde la IA puede ayudar)
- Hacer pairing reviews: revisar juntos, no solo asignar y esperar

El code review tiene valor principalmente como mecanismo de transferencia de conocimiento y como segunda línea de defensa contra errores de lógica. Ninguna de esas funciones desaparece por usar IA.

### 4. Testing: la IA asiste, los humanos validan

Los tests generados por IA son un punto de partida valioso, no un punto de llegada. El proceso debería ser:

1. La IA genera casos de prueba básicos (happy path, errores obvios)
2. El developer revisa y pregunta: *¿qué casos de borde no están cubiertos?*
3. El developer añade los tests que requieren conocimiento de dominio
4. Alguien más revisa que los tests realmente ejerciten el comportamiento esperado, no solo el comportamiento implementado

Los tests son la especificación ejecutable de cómo debe comportarse el sistema. Esa especificación debe provenir del entendimiento humano del dominio.

### 5. Construir comprensión, no solo output

Esta es quizás la más difícil de implementar pero la más importante a largo plazo: los developers necesitan *entender* el código que generan con IA, no solo enviarlo.

Esto implica un cambio de mentalidad. En lugar de "pídele a la IA que implemente X y revisa que funcione", el flujo debería ser "pídele a la IA que implemente X, léelo con atención, entiende cada parte, y si hay algo que no entiendes, pregunta hasta que lo entiendas".

La IA puede ser un maestro extraordinario si la usamos para aprender, no solo para producir.

---

## Reflexión final: la herramienta no es el problema, el contexto sí

Hay una tensión real en todo esto que no quiero ignorar. Las empresas tienen presión por velocidad. Los developers tienen presión por cerrar tickets. Las herramientas de IA son genuinamente poderosas y las ganancias de productividad son reales.

No estoy diciendo que el entusiasmo esté mal. Estoy diciendo que el entusiasmo sin guardrails crea deuda cultural además de deuda técnica.

El fenómeno de "la IA me lo dijo" es sintomático de algo más profundo: cuando la velocidad se convierte en el único valor medido, la comprensión, la responsabilidad y el criterio quedan en segundo plano. Y esas son, paradójicamente, las cosas que hacen que un equipo sea rápido a largo plazo.

Un equipo que entiende su código puede moverse rápido con confianza. Un equipo que tiene código que nadie entiende del todo está sentado sobre una deuda que algún día vence con intereses.

Las herramientas de IA, usadas bien, son multiplicadores de capacidad. Usadas sin criterio, son multiplicadores de velocidad a corto plazo y de complejidad a largo plazo.

La diferencia entre uno y otro no la pone la herramienta. La ponemos nosotros.

---

## Referencias y fuentes

- [GitHub: Survey — The AI wave continues to grow on software development teams (2024)](https://github.blog/news-insights/research/survey-ai-wave-grows/)
- [GitHub: Research — Quantifying GitHub Copilot's impact on developer productivity (2022)](https://github.blog/2022-09-07-research-quantifying-github-copilots-impact-on-developer-productivity-and-happiness/)
- [GitHub: Research — Quantifying GitHub Copilot's impact in the enterprise with Accenture (2024)](https://github.blog/2024-05-13-research-quantifying-github-copilots-impact-in-the-enterprise-with-accenture/)
- [Martin Fowler: On the Size of Pull Requests](https://martinfowler.com/articles/ship-show-ask.html)
- [Thoughtworks Technology Radar — AI-assisted development](https://www.thoughtworks.com/radar)
- [Stack Overflow Developer Survey 2024 — AI Tools](https://survey.stackoverflow.co/2024/)
