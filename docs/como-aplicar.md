# Cómo aplicar Harness Engineering a un proyecto

> Guía para agentes y humanos: adoptar el harness en proyectos **nuevos** o **existentes**
> (legacy, monolitos, microservicios, scripts, datos, etc.) sin romper lo que ya funciona.

Léela junto con [explicacion-arquitectura.md](explicacion-arquitectura.md) y usa [plantilla/](../plantilla/) como base.

---

## Para agentes: protocolo rápido

```
1. audit-harness.sh <proyecto>     → ver gaps
2. Explorar proyecto objetivo      → stack, docs existentes, tests, riesgos
3. Fusionar plantilla/             → solo lo que falta
4. Migrar conocimiento → memory/   → hechos no obvios
5. Codificar reglas → docs/        → desde código y convenciones reales
6. Adaptar init.sh                 → tests/comandos del stack
7. ./init.sh verde                 → verificar
8. memory/adopcion-harness.md      → dejar constancia de decisiones
```

---

## Paso 1 — Diagnóstico (no tocar código aún)

### Ejecutar auditoría

Desde este kit:

```bash
./scripts/audit-harness.sh /ruta/al/proyecto-objetivo
```

La salida lista artefactos **presentes**, **faltantes** y **recomendados**.

### Explorar el proyecto objetivo

| Pregunta | Dónde mirar |
|----------|-------------|
| ¿Qué hace el proyecto? | README, package.json, pyproject.toml, main |
| ¿Qué stack usa? | Dependencias, Dockerfile, CI |
| ¿Hay tests? | `tests/`, `*_test.go`, scripts en CI |
| ¿Hay docs de arquitectura? | README, `docs/`, wiki, ADRs |
| ¿Usa MCP / APIs / DB? | Config IDE, `.env.example`, deploy |
| ¿Qué reglas ya existen? | linter, pre-commit, CONTRIBUTING |

**Objetivo:** mapear lo existente a los tres pilares antes de copiar archivos.

---

## Paso 2 — Mapear lo existente a los pilares

| Pilar | ¿Ya existe algo similar? | Acción |
|-------|--------------------------|--------|
| **Contexto** | README largo, wiki, `.cursorrules` | Extraer a `memory/`; dejar mapa en `AGENTS.md` |
| **Control** | CI, linter, CONTRIBUTING | Formalizar en `docs/` + `CHECKPOINTS.md` + `init.sh` |
| **Orquestación** | Issues, kanban, «cómo trabajamos» | `feature_list.json` + `progress/` |
| **Seguridad** | `.gitignore`, secret scanning | Completar plano según [security-plane.md](security-plane.md) |

**Regla:** si el proyecto ya tiene `docs/architecture.md` (u equivalente), **no lo reemplaces** —
complétalo o enlázalo desde `AGENTS.md`.

---

## Paso 3 — Adopción por fases

### Fase 1 — Contexto mínimo (día 1)

Copiar o crear:

| Archivo | Acción |
|---------|--------|
| `AGENTS.md` | Mapa del repo; enlazar docs existentes |
| `CLAUDE.md` | Si usan Claude Code; puede ser corto y apuntar a `AGENTS.md` |
| `AGENT.md` | Opcional; alias para herramientas que buscan este nombre |
| `MEMORY.md` + `memory/` | Índice vacío; migrar 3–5 hechos críticos del README/wiki |
| `SKILLS.md` | Solo si hay queries/comandos repetidos |
| `progress/current.md`, `history.md` | Estado de sesión |

**Cursor:** copiar `plantilla/.cursor/rules/harness.mdc` → `.cursor/rules/` del objetivo.

### Fase 2 — Control (día 1–2)

| Archivo | Acción |
|---------|--------|
| `feature_list.json` | Listar trabajo pendiente real (de issues, TODOs, roadmap) |
| `docs/architecture.md` | Escribir o **importar** principios del proyecto existente |
| `docs/conventions.md` | Desde linter config + estilo real del código |
| `docs/verification.md` | Comandos de test que ya usa el proyecto |
| `CHECKPOINTS.md` | Checklist de cierre de sesión |
| `init.sh` | Gates: archivos base + validación feature_list + **tests del stack** |

### Fase 3 — Orquestación ligera

- Protocolo en `CLAUDE.md` / `AGENTS.md`: una feature a la vez, humano aprueba cierre.
- `progress/current.md` durante sesiones de agente.
- **No** añadir `.claude/agents/` salvo petición explícita (Modo B).

### Fase 4 — Seguridad (proporcional)

| Riesgo del proyecto | Qué añadir |
|---------------------|------------|
| CLI local, sin secretos | `.gitignore` + bloque secretos en `init.sh` + CHECKPOINTS |
| MCP / APIs | `docs/security.md` + tabla de permisos MCP |
| Deploy / puertos | `docs/DEPLOY.md` + CI |

Ver [security-plane.md](security-plane.md).

---

## Proyecto nuevo vs proyecto existente

### Proyecto nuevo (greenfield)

```bash
cp -r /ruta/a/harness-eng/plantilla/ ./mi-proyecto/
cd mi-proyecto
# Personalizar CLAUDE.md, docs/, feature_list.json
chmod +x init.sh && ./init.sh
```

Rellenar `docs/architecture.md` antes de la primera feature.

### Proyecto existente (brownfield / legacy)

1. **No borrar** README, docs ni CI existentes.
2. Auditoría → gaps.
3. Añadir solo archivos faltantes desde `plantilla/`.
4. **Fusionar** contenido:
   - README «Cómo contribuir» → `docs/conventions.md`
   - Decisiones en wiki → `memory/*.md`
   - Issues abiertos → `feature_list.json` (priorizar)
5. `init.sh` debe llamar al **mismo comando de test que ya usa CI**:
   ```bash
   # Ejemplos — elegir el que aplique
   npm test
   pytest
   go test ./...
   python3 -m unittest discover -s tests
   ```
6. Si no hay tests: primera feature en `feature_list.json` = «añadir tests mínimos».

### Proyecto con arquitectura similar (otro harness parcial)

Muchos repos ya tienen piezas sueltas (`CONTRIBUTING.md`, `.cursorrules`, `Makefile`).

| Ya tiene | Equivalencia harness | Acción |
|----------|---------------------|--------|
| `CONTRIBUTING.md` | Control | Resumir en `docs/conventions.md`; enlazar original |
| `.cursor/rules/` | Contexto + Control | Añadir `harness.mdc`; no duplicar reglas |
| `Makefile` / `justfile` | Control (gates) | `init.sh` puede delegar: `make check` |
| `TODO.md` | Control (alcance) | Migrar a `feature_list.json` |
| `.env.example` | Seguridad | Mantener; nunca valores reales en `memory/` |

---

## Paso 4 — Adaptar `init.sh` al stack

Plantilla genérica. **Personalizar** el bloque de tests:

```bash
echo "── Tests ──"
if [ -f package.json ] && grep -q '"test"' package.json 2>/dev/null; then
  npm test --silent && ok "npm test" || { fail "npm test"; EXIT=1; }
elif [ -d tests ] && ls tests/*.py >/dev/null 2>&1; then
  python3 -m unittest discover -s tests -q && ok "unittest" || { fail "tests"; EXIT=1; }
elif [ -f go.mod ]; then
  go test ./... && ok "go test" || { fail "go test"; EXIT=1; }
else
  echo "[WARN] Sin tests configurados — añadir en docs/verification.md"
fi
```

El gate debe reflejar **la verdad del proyecto**, no un stack inventado.

---

## Paso 5 — Aprender y persistir

Al cerrar la adopción, crear en el **proyecto objetivo**:

`memory/adopcion-harness.md`:

```markdown
---
name: adopcion-harness
description: Decisiones tomadas al adoptar harness engineering
metadata:
  type: project
---

- Qué archivos se añadieron y cuáles ya existían
- Comando de test oficial: `...`
- Nivel de seguridad: minimal | mcp | deploy
- Orquestación: humano (Modo A)

**Why**: Para que futuras sesiones no repitan el diagnóstico.

**How to apply**: Consultar antes de reestructurar el harness.
```

Actualizar `MEMORY.md` con el enlace.

---

## Compatibilidad por herramienta

| Herramienta | Configuración en proyecto objetivo |
|-------------|-----------------------------------|
| **Cursor** | `AGENTS.md` + `.cursor/rules/harness.mdc` |
| **Claude Code** | `CLAUDE.md` en raíz |
| **VS Code + Copilot** | `AGENTS.md`; opcional `.github/copilot-instructions.md` con: «Lee AGENTS.md al iniciar» |
| **Windsurf / otros** | `AGENTS.md` como mapa universal |

Todos convergen en los mismos archivos de harness; solo cambia el **punto de entrada** que carga el IDE.

---

## Errores al adoptar

| Error | Corrección |
|-------|------------|
| Copiar plantilla encima de docs existentes | Fusionar; `AGENTS.md` enlaza lo viejo y lo nuevo |
| `init.sh` con tests que el proyecto no tiene | Adaptar al comando real de CI |
| Duplicar reglas en CLAUDE.md, AGENTS.md y rules | Un tema = un archivo canónico |
| feature_list vacío o inventado | Poblar desde issues/TODOs reales |
| Seguridad deploy en un script local | Usar plantilla minimal |
| Subagentes autónomos de inicio | Modo A primero; Modo B solo con madurez |

---

## Verificación final

En el **proyecto objetivo**:

```bash
./init.sh                    # verde
./scripts/audit-harness.sh . # desde kit, o copiar script al objetivo
```

Checklist humano:

- [ ] Un agente nuevo puede abrir `AGENTS.md` y saber qué leer
- [ ] Hay al menos una feature `pending` real
- [ ] `docs/verification.md` tiene comandos que funcionan
- [ ] No hay secretos en `memory/` ni en el diff
- [ ] `memory/adopcion-harness.md` documenta la adopción

---

## Ver también

- [explicacion-arquitectura.md](explicacion-arquitectura.md)
- [security-plane.md](security-plane.md)
- [glosario.md](glosario.md)
- [plantilla/](../plantilla/)
