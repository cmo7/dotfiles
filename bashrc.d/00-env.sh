# ───────────── Detección de sistema ─────────────
# Detectar el sistema operativo sin usar uname
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  export OS_TYPE="windows"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export OS_TYPE="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export OS_TYPE="mac"
else
  export OS_TYPE="unknown"
fi

if grep -qi microsoft /proc/version 2>/dev/null; then
  export IS_WSL=true
else
  export IS_WSL=false
fi
