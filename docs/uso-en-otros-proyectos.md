# Cómo usar este kit en otros proyectos

Este repositorio **no es una aplicación**. Es un kit para que tus proyectos (en cualquier carpeta) tengan harness engineering: contexto, control, orquestación y seguridad.

---

## En 30 segundos

1. **Audita** el proyecto donde quieres aplicar harness.
2. **Copia o fusiona** solo lo que falta desde `plantilla/`.
3. **Adapta** `init.sh` al comando de tests de ese proyecto.
4. **Verifica** con `./init.sh` verde.

---

## Paso 1 — Auditar tu proyecto

Desde este kit (ajusta la ruta):

```bash
cd /Volumes/JMTSSD/harness-eng
./scripts/audit-harness.sh /ruta/a/tu-proyecto
```

La salida dice qué archivos **faltan** y cuáles **ya tienes**.

Ejemplo:

```bash
./scripts/audit-harness.sh ~/proyectos/mi-app
```

---

## Paso 2 — Aplicar

### Proyecto nuevo (carpeta vacía o recién creado)

```bash
cp -r /Volumes/JMTSSD/harness-eng/plantilla/ /ruta/a/tu-proyecto/
cd /ruta/a/tu-proyecto
chmod +x init.sh
```

Edita `CLAUDE.md`, `docs/` y `feature_list.json` con lo tuyo.

### Proyecto que ya existe (con o sin harness parcial)

**No sobrescribas** archivos que ya tengas (`AGENTS.md`, `docs/architecture.md`, etc.).

1. Mira qué marcó la auditoría como **FALTA**.
2. Copia **solo esos** archivos desde `plantilla/`.
3. Si ya tienes `AGENTS.md` o `README.md` con reglas, **fusiona**: enlaza desde `AGENTS.md` lo que ya existía.

| Si ya tienes… | Haz esto |
|---------------|----------|
| `AGENTS.md` / `AGENT.md` | Complétalo con el mapa de la plantilla; no lo borres |
| `docs/` con arquitectura | Consérvalo; añade solo lo que falte |
| Tests en CI | Pon el mismo comando en `init.sh` y `docs/verification.md` |
| `.cursor/rules/` | Añade `plantilla/.cursor/rules/harness.mdc` |

---

## Paso 3 — Adaptar `init.sh`

Abre `init.sh` en tu proyecto y asegúrate de que el bloque de tests use **tu** stack:

```bash
npm test          # Node
pytest            # Python
go test ./...     # Go
make test         # si ya tienes Makefile
```

---

## Paso 4 — Verificar

```bash
cd /ruta/a/tu-proyecto
./init.sh
```

Tiene que terminar en verde. Si falla, corrige antes de seguir trabajando con agentes.

Opcional: vuelve a auditar:

```bash
/Volumes/JMTSSD/harness-eng/scripts/audit-harness.sh .
```

---

## Usar con Cursor o Claude Code

1. Abre **tu proyecto** en el IDE.
2. Pide al agente algo como:

> Usa el kit harness en `/Volumes/JMTSSD/harness-eng` (o `~/harness-eng`).  
> Audita este repo, aplica lo que falte desde `plantilla/` sin pisar mis docs, y deja `./init.sh` verde.

El agente debe leer `AGENTS.md` y `docs/como-aplicar.md` del kit.

Si no tienes el kit local:

```bash
git clone https://github.com/jmoralest/harness-eng.git ~/harness-eng
```

---

## Qué archivos lleva la plantilla

| Archivo | Para qué |
|---------|----------|
| `AGENTS.md` | Mapa del proyecto (Cursor y agentes) |
| `CLAUDE.md` | Entrada Claude Code |
| `MEMORY.md` + `memory/` | Aprendizajes entre sesiones |
| `SKILLS.md` | Recetas reutilizables |
| `feature_list.json` | Tareas y alcance |
| `CHECKPOINTS.md` | Checklist al cerrar sesión |
| `init.sh` | Comprobaciones automáticas |
| `docs/` | Arquitectura, convenciones, verificación, seguridad |
| `progress/` | Estado de la sesión |
| `.cursor/rules/harness.mdc` | Regla Cursor |

---

## Preguntas frecuentes

**¿Puedo aplicarlo a proyectos en otras carpetas?**  
Sí. La ruta no importa; usa `audit-harness.sh` con la ruta absoluta.

**¿Y si ya tiene algo de harness?**  
Mejor. Audita, fusiona lo que falta y no dupliques reglas.

**¿Tengo que usar subagentes autónomos?**  
No. Por defecto **tú** orquestas; la plantilla va en modo humano.

**¿Dónde profundizar?**  
- [como-aplicar.md](como-aplicar.md) — guía completa brownfield/greenfield  
- [explicacion-arquitectura.md](explicacion-arquitectura.md) — pilares del harness  
- [security-plane.md](security-plane.md) — seguridad según riesgo  
