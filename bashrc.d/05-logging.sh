# ───────────────────────────────────────────────────────────────
# LOGGING UTILITIES
# ───────────────────────────────────────────────────────────────
# Sistema de logging centralizado para dotfiles
# ───────────────────────────────────────────────────────────────

# Colores ANSI (solo definir si no existen)
if [[ -z "${RED:-}" ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly PURPLE='\033[0;35m'
    readonly CYAN='\033[0;36m'
    readonly NC='\033[0m' # No Color
fi

# Funciones de logging
log_info() {
    echo -e "${BLUE}ℹ️  $*${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $*${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $*${NC}"
}

log_error() {
    echo -e "${RED}❌ $*${NC}" >&2
}

log_debug() {
    [[ "${DEBUG:-}" == "true" ]] && echo -e "${PURPLE}🐛 $*${NC}" >&2
}

# Función para verificar dependencias
check_deps() {
    local missing_deps=()
    for cmd in "$@"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Dependencias faltantes: ${missing_deps[*]}"
        return 1
    fi
    return 0
}
