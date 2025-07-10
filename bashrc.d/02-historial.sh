# Configuración de historial
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%F %T '
shopt -s histappend
shopt -s cmdhist

# Función para usar fzf para buscar en el historial
fzf_history() {
    # Verificar si fzf está instalado
    if ! command -v fzf &> /dev/null; then
        echo "fzf no está instalado. Por favor, instálalo primero."
        return 1
    fi

    # Obtener el historial de comandos sin números de línea ni timestamps
    local history=$(history | sed 's/^[ ]*[0-9]\+[ ]\+[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}:[0-9]\{2\} //')

    # Usar fzf para seleccionar un comando del historial
    local selected=$(echo "$history" | fzf --height 40% --reverse --border --prompt "Selecciona un comando: ")

    # Si se seleccionó un comando, ejecutarlo
    if [[ -n "$selected" ]]; then
        # Agregar el comando al historial y ejecutarlo
        history -s "$selected"
        eval "$selected"
    else
        echo "No se seleccionó ningún comando."
    fi
}

# Alias para usar fzf_history
alias h='fzf_history'