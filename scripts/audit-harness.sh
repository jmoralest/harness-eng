#!/usr/bin/env bash
# audit-harness.sh — Diagnóstico de gaps de harness en un proyecto
# Uso: ./scripts/audit-harness.sh /ruta/al/proyecto
# Exit 0 = todos los obligatorios presentes; 1 = faltan obligatorios

set -u
TARGET="${1:-.}"
TARGET="$(cd "$TARGET" && pwd)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; NC='\033[0m'
ok()   { printf "  ${GREEN}OK${NC}    %s\n" "$1"; }
miss() { printf "  ${RED}FALTA${NC} %s\n" "$1"; MISSING=$((MISSING + 1)); }
warn() { printf "  ${YELLOW}OPC${NC}   %s\n" "$1"; OPTIONAL_MISS=$((OPTIONAL_MISS + 1)); }
has()  { [ -e "$TARGET/$1" ]; }

MISSING=0
OPTIONAL_MISS=0

echo "Auditoría harness: $TARGET"
echo "══════════════════════════════════════════════════════"

echo ""
echo "── Contexto (obligatorio parcial) ──"
if has AGENTS.md; then ok "AGENTS.md"; elif has AGENT.md; then ok "AGENT.md (alias)"; else miss "AGENTS.md o AGENT.md"; fi
has CLAUDE.md && ok "CLAUDE.md" || warn "CLAUDE.md (Claude Code)"
has MEMORY.md && ok "MEMORY.md" || warn "MEMORY.md"
has memory && ok "memory/" || warn "memory/"
has SKILLS.md && ok "SKILLS.md" || warn "SKILLS.md"
has progress/current.md && ok "progress/current.md" || miss "progress/current.md"
has progress/history.md && ok "progress/history.md" || warn "progress/history.md"

echo ""
echo "── Control (obligatorio) ──"
has feature_list.json && ok "feature_list.json" || miss "feature_list.json"
has CHECKPOINTS.md && ok "CHECKPOINTS.md" || miss "CHECKPOINTS.md"
has init.sh && ok "init.sh" || miss "init.sh"
has docs/architecture.md && ok "docs/architecture.md" || miss "docs/architecture.md"
has docs/conventions.md && ok "docs/conventions.md" || miss "docs/conventions.md"
has docs/verification.md && ok "docs/verification.md" || miss "docs/verification.md"

echo ""
echo "── Orquestación ──"
if has AGENTS.md && grep -q -i "orquest\|feature_list\|progress" "$TARGET/AGENTS.md" 2>/dev/null; then
  ok "Protocolo de sesión en AGENTS.md"
else
  warn "Protocolo de orquestación en AGENTS.md/CLAUDE.md"
fi

echo ""
echo "── Seguridad ──"
has .gitignore && ok ".gitignore" || warn ".gitignore"
has docs/security.md && ok "docs/security.md" || warn "docs/security.md (si MCP/red/deploy)"
if has init.sh && grep -q -i "secret\|\.env" "$TARGET/init.sh" 2>/dev/null; then
  ok "init.sh incluye chequeo de secretos"
else
  warn "init.sh sin bloque de secretos"
fi
has .cursor/rules/harness.mdc && ok ".cursor/rules/harness.mdc" || warn ".cursor/rules/harness.mdc (Cursor)"

echo ""
echo "── Señales de stack (información) ──"
has package.json && echo "  · Node.js (package.json)"
has pyproject.toml && echo "  · Python (pyproject.toml)"
has requirements.txt && echo "  · Python (requirements.txt)"
has go.mod && echo "  · Go (go.mod)"
has Cargo.toml && echo "  · Rust (Cargo.toml)"
has tests && echo "  · tests/"
has .github/workflows && echo "  · CI (.github/workflows)"

echo ""
echo "══════════════════════════════════════════════════════"
if [ "$MISSING" -eq 0 ]; then
  printf "${GREEN}Obligatorios: completos${NC}"
else
  printf "${RED}Obligatorios faltantes: %d${NC}" "$MISSING"
fi
echo ""
if [ "$OPTIONAL_MISS" -gt 0 ]; then
  printf "${YELLOW}Recomendados opcionales pendientes: %d${NC}\n" "$OPTIONAL_MISS"
fi
echo ""
echo "Siguiente paso: docs/como-aplicar.md + copiar gaps desde plantilla/"

[ "$MISSING" -eq 0 ]
exit $?
