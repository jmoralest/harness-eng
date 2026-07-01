# CLAUDE.md — Kit Harness Engineering

Este directorio es un **kit de referencia** para adoptar harness engineering en otros proyectos.

## Al iniciar

1. Lee `AGENTS.md` — protocolo completo para agentes.
2. Si el usuario quiere aplicar harness a otro repo → `docs/como-aplicar.md` + `scripts/audit-harness.sh`.

## Reglas críticas

- No trates este repo como app a implementar: es documentación + plantilla.
- Al adoptar en otro proyecto: **auditar primero**, fusionar después, no sobrescribir ciego.
- Orquestador humano por defecto; subagentes autónomos solo si el usuario lo pide.
