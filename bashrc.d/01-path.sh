export PATH="$HOME/.local/bin:$PATH"

if [[ "$OS_TYPE" == "windows" ]]; then
  export SCOOP_DIR="$HOME/scoop"
  export PATH="$SCOOP_DIR/shims:$SCOOP_DIR/apps/scoop/current/bin:$PATH"
fi

scoop_path() {
  local app="$1"
  echo "${SCOOP_DIR:-$HOME/scoop}/apps/$app/current"
}

if [[ -d "$SCOOP_DIR/apps/zulu8-jdk/current" ]]; then
  export JAVA_HOME=$(scoop_path zulu8-jdk)
fi
