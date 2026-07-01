# Plantilla de harness

Copia al **proyecto objetivo** (nuevo o existente). Ver [../docs/como-aplicar.md](../docs/como-aplicar.md) para brownfield.

```bash
cp -r plantilla/ /ruta/mi-proyecto/
cd /ruta/mi-proyecto && chmod +x init.sh && ./init.sh
```

## Incluye

| Archivo | IDE / herramienta |
|---------|-------------------|
| `AGENTS.md` | Cursor, agentes universales |
| `CLAUDE.md` | Claude Code |
| `AGENT.md` | Alias AGENTS.md |
| `.cursor/rules/harness.mdc` | Cursor (always apply) |
| `.github/copilot-instructions.md` | GitHub Copilot (opcional) |

Orquestador **humano** (Modo A). Adapta `init.sh` y `docs/` al stack real.
