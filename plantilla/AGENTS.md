# AGENTS.md — Mapa para agentes

> Divulgación progresiva: lee solo lo necesario.

## Al empezar

1. `./init.sh`
2. `progress/current.md`
3. `feature_list.json` — una feature `pending`

## Mapa

| Archivo | Cuándo |
|---------|--------|
| `docs/architecture.md` | Antes de implementar |
| `docs/conventions.md` | Antes de escribir código |
| `docs/verification.md` | Antes de marcar `done` |
| `docs/security.md` | Si usas MCP, red o secretos |
| `CHECKPOINTS.md` | Antes de cerrar sesión |
| `MEMORY.md` | Si necesitas contexto acumulado |
| `SKILLS.md` | Antes de inventar código nuevo |

## Orquestación

El **humano** elige la feature, revisa el diff y aprueba el cierre. El agente implementa y documenta en `progress/current.md`.
