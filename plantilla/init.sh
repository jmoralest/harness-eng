#!/usr/bin/env bash
set -u
RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
ok()   { printf "${GREEN}[OK]${NC}   %s\n" "$1"; }
fail() { printf "${RED}[FAIL]${NC} %s\n" "$1"; }
EXIT=0

echo "── Entorno ──"
command -v git >/dev/null 2>&1 && ok "git" || { fail "git no encontrado"; exit 1; }

echo "── Archivos base ──"
for f in AGENTS.md feature_list.json progress/current.md \
         docs/architecture.md docs/conventions.md docs/verification.md CHECKPOINTS.md; do
  [ -f "$f" ] && ok "$f" || { fail "Falta $f"; EXIT=1; }
done

echo "── feature_list.json ──"
python3 -c "
import json, sys
d = json.load(open('feature_list.json'))
ip = [f for f in d['features'] if f['status'] == 'in_progress']
assert len(ip) <= 1, f'{len(ip)} features in_progress'
print('[OK]   feature_list.json válido')
" || EXIT=1

echo "── Tests (si existen) ──"
if [ -f package.json ] && python3 -c "import json; d=json.load(open('package.json')); exit(0 if 'scripts' in d and 'test' in d.get('scripts',{}) else 1)" 2>/dev/null; then
  npm test --silent 2>/dev/null && ok "npm test" || { fail "npm test"; EXIT=1; }
elif [ -d tests ] && find tests -name '*.py' -print -quit 2>/dev/null | grep -q .; then
  python3 -m unittest discover -s tests -q 2>/dev/null && ok "unittest" || { fail "unittest"; EXIT=1; }
elif [ -f go.mod ]; then
  go test ./... 2>/dev/null && ok "go test" || { fail "go test"; EXIT=1; }
else
  echo "[WARN] Sin tests detectados — configurar en docs/verification.md"
fi

echo "── Seguridad: secretos ──"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if git ls-files --error-unmatch .env 2>/dev/null; then
    fail ".env trackeado en git"; EXIT=1
  else
    ok "Sin .env trackeado"
  fi
fi

echo "── Resumen ──"
[ $EXIT -eq 0 ] && ok "Entorno listo" || fail "Resolver errores antes de avanzar"
exit $EXIT
