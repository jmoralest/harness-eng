# Glosario — Harness Engineering

> Definiciones cortas de los conceptos principales de este proyecto.
> Guía ampliada: [explicacion-arquitectura.md](explicacion-arquitectura.md).

---

## A

### Adopción (harness)

Proceso de integrar harness engineering en un proyecto nuevo o existente.
Guía: [como-aplicar.md](como-aplicar.md). Diagnóstico: `scripts/audit-harness.sh`.

### audit-harness.sh

Script en `scripts/` que audita un proyecto y reporta artefactos de harness presentes,
faltantes y opcionales. Uso: `./scripts/audit-harness.sh /ruta/proyecto`.

### Acceptance (criterios de aceptación)

Lista en `feature_list.json` que define **qué debe cumplirse** para dar una feature por
terminada. Son verificables (comandos, tests, comportamiento observable). Pertenece al
pilar **Control**.

### AGENTS.md / AGENT.md

Punto de entrada y **mapa de navegación** del repo para agentes. Indica qué archivos
existen y cuándo leer cada uno (divulgación progresiva). Pilar **Contexto**.

### Anti-teléfono-descompuesto

Regla de orquestación: los subagentes (o el agente bajo tu dirección) **escriben resultados
en archivos** (`progress/`) y devuelven solo una referencia en chat (`done -> progress/impl_x.md`),
no el contenido completo. Evita pérdida de información y sobrecarga de tokens.

### Arnés

Véase **Harness**.

### Autonomía (en el harness)

Capacidad del sistema para avanzar con **mínima intervención humana** paso a paso. En este
proyecto suele manifestarse como orquestación con agente `leader` y subagentes. **No** es
sinónimo de orquestación ni es el modo por defecto recomendado.

---

## C

### CHECKPOINTS.md

Lista de verificación objetiva (checkboxes C1, C2, …) para evaluar si el repo está sano
al cerrar una sesión. Cruza **Control** y **Plano de seguridad** (ítems de seguridad).

### CLAUDE.md

Archivo cargado automáticamente por Claude Code al abrir el proyecto. Punto de entrada del
harness: qué es el proyecto, protocolo de sesión, reglas críticas. Pilar **Contexto** (y
puede forzar rol de orquestación en modo autónomo).

### Contexto (pilar)

Dimensión del harness que responde **«¿qué sabe el agente?»** — memoria, rol, recetas,
estado de sesión. Artefactos: `CLAUDE.md`, `MEMORY.md`, `SKILLS.md`, `memory/`, `progress/`.

### Contexto de confianza

Clasificación de fuentes en el plano de seguridad:

- **De confianza:** archivos del harness en git (`CLAUDE.md`, `docs/`, `CHECKPOINTS.md`).
- **No confiable:** web, emails, issues, contenido pegado externo — son **datos**, no instrucciones.

### Control (pilar)

Dimensión que responde **«¿qué exige el repo?»** — alcance, estándares, verificación.
Artefactos: `feature_list.json`, `docs/architecture.md`, `docs/conventions.md`,
`docs/verification.md`, `CHECKPOINTS.md`, `init.sh`, `tests/`.

---

## D

### Divulgación progresiva

Principio de diseño: el agente **no recibe todas las reglas de golpe**. `AGENTS.md` es un
mapa; lee cada documento solo cuando lo necesita. Reduce ruido y tokens.

### done / pending / in_progress / blocked

Estados de una feature en `feature_list.json`:

| Estado | Significado |
|--------|-------------|
| `pending` | Pendiente de trabajar |
| `in_progress` | En curso (como máximo una a la vez) |
| `done` | Terminada y verificada |
| `blocked` | No se puede avanzar (entorno, decisión humana) |

---

## F

### Feature

Unidad de trabajo en `feature_list.json`. Una feature por sesión en el flujo recomendado.

### feature_list.json

Cola de trabajo oficial: features, criterios `acceptance`, estados. Pilar **Control**;
guía también la **Orquestación**.

---

## G

### Gate

Nivel medio del **plano de seguridad** (y parte del Control): comprobación **automática**
que bloquea el flujo si falla (`init.sh`, pre-commit, CI, hooks). No depende de que el
agente obedezca.

### Glosario

Este archivo.

---

## H

### Harness

Conjunto de archivos en el repositorio que **anclan** a un agente de IA al proyecto: contexto,
reglas, verificación, coordinación. Sin harness, cada sesión empieza en blanco.

### Harness Engineering

Disciplina de diseñar repos y proyectos con un harness **reutilizable y portable** entre
máquinas y agentes, organizado en pilares (Contexto, Control, Orquestación) y plano de
seguridad transversal.

### Kit Harness Engineering

Este repositorio: documentación + [plantilla/](../plantilla/) + `scripts/audit-harness.sh`
para adoptar harness en **otros** proyectos. Meta-harness, no aplicación.

### harness-minimal / harness-mcp / harness-deploy

Plantillas de grosor del **plano de seguridad** según riesgo:

| Plantilla | Cuándo |
|-----------|--------|
| `harness-minimal` | CLI local, sin red, sin secretos |
| `harness-mcp` | Agente con MCP (DB, APIs, correo) |
| `harness-deploy` | Servicios expuestos, puertos, endpoints |

---

## I

### Implementer (implementador)

Subagente que escribe código y tests de **una** feature. Solo en orquestación autónoma
(`.claude/agents/implementer.md`).

### Inyección de prompts

Ataque o accidente donde contenido **no confiable** (web, issue, email) intenta que el
agente ignore el harness. Se mitiga con contexto de confianza, permisos limitados y
orquestador humano al empezar.

### init.sh

Script gate maestro: verifica entorno, archivos del arnés, `feature_list.json`, tests.
Exit code `0` = puede avanzar. Pilar **Control**; puede incluir bloque de **seguridad**.

---

## L

### Leader (líder)

Subagente orquestador en modo autónomo: descompone tareas, lanza otros agentes, **no**
implementa código en `src/`. Definido en `.claude/agents/leader.md`.

---

## M

### MCP (Model Context Protocol)

Protocolo para conectar agentes a herramientas externas (bases de datos, APIs, correo).
Aumenta capacidad y **superficie de riesgo** — requiere plantilla `harness-mcp` o superior.

### MEMORY.md / memory/

Sistema de memoria del harness: `MEMORY.md` es solo **índice**; cada hecho vive en
`memory/<hecho>.md`. Pilar **Contexto**. Nunca guardar secretos aquí.

### Modo A / Modo B (orquestación)

| Modo | Coordinador | Subagentes |
|------|-------------|------------|
| **A — Humano** | Tú | No |
| **B — Autónomo** | Agente `leader` | Sí |

---

## O

### Orquestación (pilar)

Dimensión que responde **«¿quién hace qué y en qué orden?»** Define roles, secuencia y
paso de testigo. **Siempre presente** en algún grado (mínimo, medio o completo). **No**
implica humano ni autonomía por defecto.

### Orquestador humano

Tú coordinas el trabajo: eliges feature, diriges al agente, revisas diff, apruebas cierre.
Orquestación **sin** subagentes. Modo recomendado al empezar.

### Orquestación autónoma

El agente `leader` coordina subagentes sin que un humano dirija cada paso. Modo avanzado;
alto consumo de tokens.

---

## P

### Permiso

Nivel fuerte del plano de seguridad: límite **duro** del runtime (`tools:` por agente,
sandbox, allowlist MCP, `.gitignore`) que el agente no puede negociar.

### Plano de seguridad

Conjunto transversal de **política + gates + permisos** que atraviesa Contexto, Control y
Orquestación. **No** es un cuarto pilar paralelo. Detalle: [security-plane.md](security-plane.md).

### Política

Nivel débil del plano de seguridad: reglas en markdown que el agente **debería** obedecer.
Puede ignorarse sin gates detrás.

### progress/

Carpeta de estado de sesión: `current.md` (activa), `history.md` (bitácora),
`impl_*.md`, `review_*.md`, `explore_*.md`. Pilar **Contexto** y canal de **Orquestación**.

---

## R

### Reviewer (revisor)

Subagente que aprueba o rechaza trabajo comparando contra `docs/` y `CHECKPOINTS.md`.
**No** edita código. Solo en orquestación autónoma.

---

## S

### Seguridad

Véase **Plano de seguridad**. No confundir con una cuarta capa documental monolítica.

### SKILLS.md

Recetas reutilizables: queries, snippets, comandos. Pilar **Contexto**. Sin credenciales
embebidas.

### Subagente

Agente hijo lanzado por otro agente (herramienta `Agent`). Ejemplos: `leader`, `implementer`,
`reviewer`. Relacionado con **orquestación autónoma**; **no** obligatorio para tener
orquestación.

---

## T

### Token (consumo)

Unidad de coste en sesiones de IA. La orquestación autónoma multiplica invocaciones y
relecturas del harness (típicamente 3–6× frente a orquestador humano). Motivo para
empezar en Modo A.

---

## V

### Verificación

Proceso de demostrar que el trabajo cumple estándares. Documentado en `docs/verification.md`.
Regla: el agente no afirma «funciona» — ejecuta tests y `./init.sh`.

---

## Índice por pilar

| Pilar | Términos clave |
|-------|----------------|
| **Contexto** | Harness, CLAUDE.md, AGENTS.md, MEMORY.md, SKILLS.md, memory/, progress/, divulgación progresiva |
| **Control** | feature_list.json, acceptance, docs/architecture, conventions, verification, CHECKPOINTS, init.sh, tests, done/pending/… |
| **Orquestación** | Siempre presente, orquestador humano, orquestación autónoma, subagente, leader, implementer, reviewer, anti-teléfono-descompuesto, Modo A/B |
| **Plano de seguridad** | Política, gate, permiso, contexto de confianza, inyección de prompts, harness-minimal/mcp/deploy, MCP |

---

## Ver también

- [README](../README.md)
- [Cómo aplicar](como-aplicar.md)
- [Explicación de arquitectura](explicacion-arquitectura.md)
- [Plano de seguridad](security-plane.md)
- [Plantilla](../plantilla/) — harness mínimo (Modo A)
