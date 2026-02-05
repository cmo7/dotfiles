# java-auto.bash

set_java() {
  local version="$1"
  local home=""

  case "$version" in
    8|1.8)
      home="$(scoop_path zulu8-jdk)"
      ;;
    25)
      home="$(scoop_path openjdk)"
      ;;
    *)
      echo "Unsupported Java version in .java-version: '$version'"
      return 1
      ;;
  esac

  [[ -d "$home" ]] || {
    echo "Java $version not installed at: $home"
    return 1
  }

  # No-op if already active
  [[ "${JAVA_HOME:-}" == "$home" ]] && return 0

  # Remove old JAVA_HOME/bin from PATH if it exists
  if [[ -n "${JAVA_HOME:-}" ]]; then
    PATH="${PATH//:$JAVA_HOME\/bin/}"
    PATH="${PATH//$JAVA_HOME\/bin:/}"
  fi

  export JAVA_HOME="$home"
  export PATH="$JAVA_HOME/bin:$PATH"
  echo "Switched to Java $version"
}

auto_java() {
  [[ -f ".java-version" ]] || return 0

  local v
  v="$(<.java-version)"
  v="${v//[$'\t\r\n ']/}"  # Remove whitespace using Bash parameter expansion
  [[ -n "$v" ]] && set_java "$v"
}

# Hook into prompt (Git Bash-safe "chpwd")
case ";${PROMPT_COMMAND:-};" in
  *";auto_java;"*) ;;
  *) PROMPT_COMMAND="auto_java${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# Run once on shell start
auto_java
