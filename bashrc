# Mantener compatibilidad con versiones anteriores
case $- in
  *i*) ;; # Interactivo: seguir cargando
  *) return ;; # No interactivo: salir
esac

# ───────────────────────────────────────────────────────────────
# CARGA MODULAR DE CONFIGURACIONES
# ───────────────────────────────────────────────────────────────

BASHRC_D="$HOME/.bashrc.d"

if [[ -d "$BASHRC_D" ]]; then
  for script in "$BASHRC_D"/*.sh; do
    [[ -f "$script" && -r "$script" ]] && source "$script"
  done
fi
