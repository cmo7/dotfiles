# Detección del gestor de paquetes del sistema
# Cargado en 04- para que esté disponible en 40-langs.sh y 95-tools.sh

detect_package_manager() {
  for pm in scoop apt dnf pacman zypper brew; do
    if command -v "$pm" &>/dev/null; then
      echo "$pm"
      return
    fi
  done
  echo "none"
}
