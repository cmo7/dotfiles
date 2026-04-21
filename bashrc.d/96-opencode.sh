opencode_attach_local() {
    local env_file="$HOME/opencode.env"
    local instance_url password

    if ! check_deps opencode; then
        return 1
    fi

    if [[ ! -f "$env_file" ]]; then
        log_error "Archivo no encontrado: $env_file"
        return 1
    fi

    # Load local server settings on demand so secrets stay out of dotfiles.
    set -a
    # shellcheck disable=SC1090
    source "$env_file"
    set +a

    instance_url="${OPENCODE_INSTANCE_URL:-}"
    password="${OPENCODE_SERVER_PASSWORD:-}"

    if [[ -z "$instance_url" ]]; then
        log_error "Falta OPENCODE_INSTANCE_URL en $env_file"
        return 1
    fi

    if [[ -z "$password" ]]; then
        log_error "Falta OPENCODE_SERVER_PASSWORD en $env_file"
        return 1
    fi

    if [[ "$instance_url" != http://* && "$instance_url" != https://* ]]; then
        log_error "OPENCODE_INSTANCE_URL debe iniciar con http:// o https://"
        return 1
    fi

    OPENCODE_SERVER_PASSWORD="$password" opencode attach "$instance_url" "$@"
}

alias oca='opencode_attach_local'
