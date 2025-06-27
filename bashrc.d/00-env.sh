# ───────────── Detección de sistema ─────────────
OS="$(uname -s)"
case "$OS" in
  Linux*)   export OS_TYPE="linux" ;;
  Darwin*)  export OS_TYPE="mac" ;;
  CYGWIN*|MINGW*|MSYS*) export OS_TYPE="windows" ;;
  *)        export OS_TYPE="unknown" ;;
esac

if grep -qi microsoft /proc/version 2>/dev/null; then
  export IS_WSL=true
else
  export IS_WSL=false
fi
