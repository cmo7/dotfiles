gitid() {
  echo "📛 Git Identity:"
  
  local name email name_origin email_origin

  name=$(git config user.name 2>/dev/null)
  email=$(git config user.email 2>/dev/null)
  name_origin=$(git config --show-origin --get user.name 2>/dev/null)
  email_origin=$(git config --show-origin --get user.email 2>/dev/null)

  if [[ -n "$name" ]]; then
    echo "  🧑 Nombre : $name"
  else
    echo "  🧑 Nombre : ❌ No definido"
  fi

  if [[ -n "$email" ]]; then
    echo "  📧 Email  : $email"
  else
    echo "  📧 Email  : ❌ No definido"
  fi

  if [[ -n "$name_origin" || -n "$email_origin" ]]; then
    echo "  📄 Origen :"
    [[ -n "$name_origin" ]] && echo "    user.name → $name_origin"
    [[ -n "$email_origin" ]] && echo "    user.email → $email_origin"
  else
    echo "  📄 Origen : ❌ No encontrado en ninguna config"
  fi

  echo
}
