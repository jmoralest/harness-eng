# AGENTS.md — Kit Harness Engineering

> **Este repositorio es un kit de referencia**, no una aplicación.
> Su objetivo: que cualquier agente (Cursor, Claude Code, Copilot, etc.) pueda
> **auditar, adoptar y extender** harness engineering en otros proyectos.

---

## Si el usuario pide aplicar harness a otro proyecto

Sigue este protocolo **en orden**:

1. Lee [docs/como-aplicar.md](docs/como-aplicar.md) — guía completa de adopción.
2. Ejecuta auditoría del proyecto objetivo:
   ```bash
   ./scripts/audit-harness.sh /ruta/al/proyecto-objetivo
   ```
3. Lee [docs/explicacion-arquitectura.md](docs/explicacion-arquitectura.md) — solo las secciones que falten según la auditoría.
4. Copia o fusiona archivos desde [plantilla/](plantilla/) **sin destruir** lo que ya funciona en el objetivo.
5. Migra conocimiento disperso (README, comentarios, wikis) → `memory/` + `MEMORY.md`.
6. Codifica reglas implícitas del proyecto → `docs/architecture.md`, `docs/conventions.md`.
7. Adapta `init.sh` al stack del proyecto (comando de tests real).
8. Verifica: `./init.sh` verde en el proyecto objetivo.

**No reinventes** la arquitectura: adapta la plantilla al proyecto existente.

---

## Si el usuario trabaja en este repo (kit)

| Necesidad | Archivo |
|-----------|---------|
| Entender la arquitectura | [docs/explicacion-arquitectura.md](docs/explicacion-arquitectura.md) |
| Conceptos | [docs/glosario.md](docs/glosario.md) |
| Seguridad | [docs/security-plane.md](docs/security-plane.md) |
| Aplicar a otro repo | [docs/como-aplicar.md](docs/como-aplicar.md) |
| Archivos base para copiar | [plantilla/](plantilla/) |

---

## Compatibilidad IDE / herramienta

| Herramienta | Archivo de entrada en el **proyecto objetivo** |
|-------------|--------------------------------------------------|
| **Cursor** | `AGENTS.md` + `.cursor/rules/harness.mdc` (incluido en plantilla) |
| **Claude Code** | `CLAUDE.md` (apunta a `AGENTS.md`) |
| **GitHub Copilot** | `AGENTS.md` o `.github/copilot-instructions.md` (opcional, ver como-aplicar) |
| **Otros** | `AGENTS.md` como mapa universal |

---

## Reglas al adoptar

- **Orquestador humano** por defecto (Modo A). No añadir subagentes autónomos salvo petición explícita.
- **Proporcionalidad:** plano de seguridad minimal → mcp → deploy según riesgo del objetivo.
- **Un tema = un lugar de verdad.** No duplicar reglas en cinco archivos.
- Al terminar adopción: crear o actualizar `memory/adopcion-harness.md` en el proyecto objetivo con lo aprendido del dominio.

---

## Mapa de este repositorio

```
.
├── AGENTS.md              ← este archivo (entrada agentes)
├── CLAUDE.md              ← entrada Claude Code (este kit)
├── README.md              ← entrada humanos
├── docs/
│   ├── como-aplicar.md    ← adopción en proyectos nuevos/viejos
│   ├── explicacion-arquitectura.md
│   ├── security-plane.md
│   └── glosario.md
├── plantilla/             ← copiar al proyecto objetivo
└── scripts/
    └── audit-harness.sh   ← diagnóstico de gaps
```
