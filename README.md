# Harness Engineering

Kit portable para que **cualquier agente o IDE con IA** (Cursor, Claude Code, Copilot, etc.)
adopte harness engineering en proyectos nuevos o existentes.

---

## Para agentes (empezar aquí)

1. Lee **[AGENTS.md](AGENTS.md)** — protocolo y mapa de este kit.
2. Si debes aplicar harness a **otro proyecto** → **[docs/como-aplicar.md](docs/como-aplicar.md)**.
3. Diagnóstico rápido:
   ```bash
   ./scripts/audit-harness.sh /ruta/al/proyecto-objetivo
   ```

---

## Para humanos

| Documento | Contenido |
|-----------|-----------|
| [docs/explicacion-arquitectura.md](docs/explicacion-arquitectura.md) | Pilares: Contexto, Control, Orquestación |
| [docs/uso-en-otros-proyectos.md](docs/uso-en-otros-proyectos.md) | **Cómo aplicar este kit en tus proyectos** (guía simple) |
| [docs/como-aplicar.md](docs/como-aplicar.md) | Adoptar en proyecto nuevo o legacy (guía completa) |
| [docs/security-plane.md](docs/security-plane.md) | Plano de seguridad |
| [docs/glosario.md](docs/glosario.md) | Conceptos |

**Orden sugerido:** explicación → como-aplicar (si adoptas) → glosario → seguridad (según riesgo).

---

## Aplicar en otro proyecto

```bash
# 1. Diagnóstico
./scripts/audit-harness.sh ../mi-proyecto

# 2. Copiar base (proyecto nuevo) o fusionar archivos faltantes (existente)
cp -r plantilla/ ../mi-proyecto/
# Ver docs/como-aplicar.md para brownfield — no sobrescribir docs existentes

# 3. Verificar
cd ../mi-proyecto && chmod +x init.sh && ./init.sh
```

La plantilla incluye: `AGENTS.md`, `CLAUDE.md`, `AGENT.md`, `.cursor/rules/harness.mdc`, Control, gates de seguridad básicos.

---

## Arquitectura

```
                    PLANO DE SEGURIDAD
    ═══════════════════════════════════════════════
         │              │              │
    Contexto        Control       Orquestación
```

- Orquestación **siempre** presente; orquestador **humano** por defecto.
- Seguridad proporcional: minimal → mcp → deploy.

---

## Estructura del repositorio

```
.
├── AGENTS.md              ← entrada agentes (cualquier IDE)
├── CLAUDE.md              ← entrada Claude Code
├── README.md
├── docs/
│   ├── como-aplicar.md    ← adopción en otros proyectos
│   ├── explicacion-arquitectura.md
│   ├── security-plane.md
│   └── glosario.md
├── plantilla/             ← copiar al proyecto objetivo
└── scripts/
    └── audit-harness.sh
```
