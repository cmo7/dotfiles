# ───────────────────────────────────────────────────────────────
# DOTFILES MANAGEMENT
# ───────────────────────────────────────────────────────────────
# Utilidades para gestionar el repositorio de dotfiles
# ───────────────────────────────────────────────────────────────

# Función para navegar al directorio de dotfiles
dots() {
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
    if [[ -d "$dotfiles_dir" ]]; then
        cd "$dotfiles_dir"
        log_info "📁 Navegando a dotfiles: $dotfiles_dir"
    else
        log_error "Directorio de dotfiles no encontrado: $dotfiles_dir"
        return 1
    fi
}

# Función para editar configuraciones de bash
editbash() {
    local bashrc_d="${DOTFILES_DIR:-$HOME/dotfiles}/bashrc.d"
    if ! check_deps fzf; then
        log_error "fzf es requerido para esta función"
        return 1
    fi
    
    if [[ -d "$bashrc_d" ]]; then
        local file
        file=$(find "$bashrc_d" -name "*.sh" -type f | fzf --prompt="Editar archivo bash: " --height=40% --preview="bat --color=always {}")
        
        if [[ -n "$file" ]]; then
            "${EDITOR:-nvim}" "$file"
        else
            log_warning "No se seleccionó ningún archivo"
        fi
    else
        log_error "Directorio bashrc.d no encontrado: $bashrc_d"
        return 1
    fi
}

# Función para sincronizar dotfiles
dotsync() {
    local dotfiles_dir="${DOTFILES_DIR:-$HOME/dotfiles}"
    if [[ -d "$dotfiles_dir" ]]; then
        pushd "$dotfiles_dir" >/dev/null || return 1
        
        log_info "🔄 Sincronizando dotfiles..."
        
        # Pull cambios
        if git pull origin main 2>/dev/null; then
            log_success "Pull completado"
        else
            log_warning "No se pudo hacer pull (puede que no haya cambios)"
        fi
        
        # Reinstalar
        if ./install.sh; then
            log_success "Dotfiles reinstalados"
            log_info "💡 Ejecuta 'reload' para aplicar cambios"
        else
            log_error "Error en la instalación"
        fi
        
        popd >/dev/null || return 1
    else
        log_error "Directorio de dotfiles no encontrado: $dotfiles_dir"
        return 1
    fi
}

# Aliases
alias dotfiles='dots'
alias edbash='editbash'
