#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts (Versión MiauNord)
# ========================================================
# Este script instala meow-colorscripts con toque felino y paleta Nord:
# • Selecciona y guarda el idioma en ~/.config/meow-colorscripts/lang.
# • Clona el repositorio (si no existe) en ~/meow-colorscripts.
# • Mueve la carpeta de configuración a ~/.config/meow-colorscripts (si existe en el repositorio; 
#   en caso contrario, no se muestra error).
# • Instala en ~/.local/bin los siguientes comandos (sin la extensión .sh):
#       - meow-colorscripts          (comando principal que muestra un meow RANDOM)
#       - meow-colorscripts-update   (desde update.sh)
#       - meow-colorscripts-setup    (desde setup.sh)
#       - meow-colorscripts-names    (muestra el contenido de names.txt)
#       - meow-colorscripts-show     (para mostrar arte ASCII específico)
#       - meow-colorscripts-uninstall (desde uninstall.sh)
# • Actualiza el PATH según la shell del usuario.
# • Muestra mensajes vibrantes usando la paleta Nord e íconos de Nerd Fonts.
# ========================================================

export TERM=${TERM:-xterm-256color}

# --- Paleta Nord Aurora usando secuencias ANSI ---
NORD0="\033[38;2;46;52;64m"    # Fondo oscuro
NORD1="\033[38;2;59;66;82m"
NORD2="\033[38;2;67;76;94m"
NORD3="\033[38;2;76;86;106m"
NORD4="\033[38;2;216;222;233m"  # Texto claro principal
NORD5="\033[38;2;229;233;240m"
NORD6="\033[38;2;236;239;244m"
NORD7="\033[38;2;143;188;187m"  # Verde/acento
NORD8="\033[38;2;136;192;208m"  # Cian/acento
NORD9="\033[38;2;129;161;193m"  # Azul claro
NORD10="\033[38;2;94;129;172m"  # Azul oscuro

GREEN="$NORD7"
RED="$NORD1"
YELLOW="$NORD9"
CYAN="$NORD8"
MAGENTA="$NORD10"
WHITE="$NORD4"
NC='\033[0m'  # Reset

# ------------------------------
# Funciones de mensajes bilingües
# ------------------------------
# Uso: print_msg "Mensaje en español" "Message in English"
print_msg() {
  if [ "$LANGUAGE" = "es" ]; then
    printf "%b\n" "$1"
  else
    printf "%b\n" "$2"
  fi
}

# Función para mensajes dinámicos con ícono (Nerd Fonts)
print_dynamic_message() {
  local message="$1"
  local delay=0.2
  printf "%b" "${MAGENTA}${message}${NC}"
  for i in {1..3}; do
    printf "."
    sleep $delay
  done
  printf " %b\n" "${GREEN}${NC}"
}

# ------------------------------
# Directorios y rutas base
# ------------------------------
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# ---------------------------------------
# 1. Seleccionar el idioma y exportar a LANG
# ---------------------------------------
printf "\n${CYAN}▸ Select your language:${NC}\n"
printf "  ${YELLOW}1) Español${NC}\n"
printf "  ${YELLOW}2) English${NC}\n"
printf "${CYAN}▸ Choose an option [1/2]: ${NC}"
read LANG_OPTION
LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
  LANGUAGE="es"
fi
mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"
export LANG="$LANGUAGE"
print_msg "¡Idioma establecido!" "Language set!"

# ---------------------------------------
# 2. Clonar el repositorio y mover la carpeta de configuración
# ---------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
  if [ "$LANGUAGE" = "es" ]; then
    print_msg "▸ No se encontró $LOCAL_REPO. Clonando repositorio..." ""
  else
    print_msg "▸ Repository not found at $LOCAL_REPO. Cloning repository..." ""
  fi
  # Reemplaza la URL por la de tu repositorio:
  git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO" || { 
    print_msg "${RED}✖ Error clonando el repositorio." "${RED}✖ Error cloning repository."
    exit 1
  }
fi

# Asegurarse de que todos los scripts sean ejecutables
find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

# Mover la carpeta de configuración (si existe) a ~/.config/meow-colorscripts
if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
  rm -f "$LOCAL_REPO/.config/meow-colorscripts/meow.conf" "$LOCAL_REPO/.config/meow-colorscripts/lang"
  rm -rf "$CONFIG_DIR" 2>/dev/null
  mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
  print_dynamic_message "Carpeta miauctaida a $CONFIG_DIR"
fi
# Si no se encuentra la carpeta de configuración en el repositorio, no se muestra error.

# ---------------------------------------
# 3. Instalación de comandos en ~/.local/bin
# ---------------------------------------
mkdir -p "$BIN_DIR"
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  CURRENT_SHELL=$(basename "$SHELL")
  case "$CURRENT_SHELL" in
    bash)
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
      ;;
    zsh)
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
      ;;
    *)
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
      ;;
  esac
  export PATH="$BIN_DIR:$PATH"
fi
print_dynamic_message "PATH miauctaizado"  # Mensaje sin traducción específica.

# ---------------------------------------
# 4. Instalar el comando PRINCIPAL: "meow-colorscripts"
#     (Muestra un meow RANDOM de la carpeta de arte)
# ---------------------------------------
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
  install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-colorscripts"
  print_dynamic_message "meow-colorscripts instalado"
elif [ -f "$LOCAL_REPO/show-meows.sh" ]; then
  install -Dm755 "$LOCAL_REPO/show-meows.sh" "$BIN_DIR/meow-colorscripts"
  print_dynamic_message "meow-colorscripts instalado"
else
  if [ "$LANGUAGE" = "es" ]; then
    print_msg "▸ No se encontró 'show-meows.sh' para el comando principal, se creará un fallback..." ""
  else
    print_msg "▸ 'show-meows.sh' not found for main command; creating a fallback..." ""
  fi
  cat << 'EOF' > "$CONFIG_DIR/show-meows.sh"
#!/bin/bash
# Fallback para meow-colorscripts
CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "No se encontró el archivo de configuración. Ejecuta meow-colorscripts-setup primero."
  exit 1
fi

source "$CONFIG_FILE"
ART_DIR="$CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE"
if [ ! -d "$ART_DIR" ]; then
  echo "La carpeta de arte ($ART_DIR) no existe."
  exit 1
fi

FILES=("$ART_DIR"/*.txt)
if [ ${#FILES[@]} -eq 0 ]; then
  echo "No hay archivos de arte en $ART_DIR."
  exit 1
fi

RANDOM_FILE=${FILES[RANDOM % ${#FILES[@]}]}
echo -e "$(<"$RANDOM_FILE")"
EOF
  chmod +x "$CONFIG_DIR/show-meows.sh"
  install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-colorscripts"
  print_dynamic_message "meow-colorscripts (fallback) instalado"
fi

# ---------------------------------------
# 5. Instalar comando "meow-colorscripts-update" (desde update.sh)
# ---------------------------------------
if [ -f "$LOCAL_REPO/update.sh" ]; then
  install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/meow-colorscripts-update"
  print_dynamic_message "meow-colorscripts-update instalado"
else
  print_msg "${RED}✖ No se encontró update.sh en el repositorio." "${RED}✖ update.sh not found in repository."
fi

# ---------------------------------------
# 6. Instalar comando "meow-colorscripts-setup" (desde setup.sh)
# ---------------------------------------
if [ -f "$SETUP_SCRIPT" ]; then
  install -Dm755 "$SETUP_SCRIPT" "$BIN_DIR/meow-colorscripts-setup"
  print_dynamic_message "meow-colorscripts-setup instalado"
else
  print_msg "${RED}✖ No se encontró setup.sh en el repositorio." "${RED}✖ setup.sh not found in repository."
fi

# ---------------------------------------
# 7. Instalar comando "meow-colorscripts-names" (muestra el contenido de names.txt)
# ---------------------------------------
{
  echo "#!/bin/bash"
  echo "cat $CONFIG_DIR/names.txt"
} > "$BIN_DIR/meow-colorscripts-names"
chmod +x "$BIN_DIR/meow-colorscripts-names"
print_dynamic_message "meow-colorscripts-names instalado"

# ---------------------------------------
# 8. Instalar comando "meow-colorscripts-show" (para mostrar arte específico)
# ---------------------------------------
if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
  install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
  print_dynamic_message "meow-colorscripts-show instalado"
elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
  install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
  print_dynamic_message "meow-colorscripts-show instalado"
else
  print_msg "${RED}✖ No se encontró 'meow-colorscripts-show.sh'." "${RED}✖ 'meow-colorscripts-show.sh' not found."
fi

# ---------------------------------------
# 9. Instalar comando "meow-colorscripts-uninstall" (desde uninstall.sh)
# ---------------------------------------
if [ -f "$LOCAL_REPO/uninstall.sh" ]; then
  install -Dm755 "$LOCAL_REPO/uninstall.sh" "$BIN_DIR/meow-colorscripts-uninstall"
  print_dynamic_message "meow-colorscripts-uninstall instalado"
else
  print_msg "${RED}✖ No se encontró uninstall.sh en el repositorio." "${RED}✖ uninstall.sh not found in repository."
fi

# ---------------------------------------
# 10. Mensaje final y pregunta para iniciar la configuración
# ---------------------------------------
print_msg "▸ Reinicia tu terminal para que los cambios surtan efecto." "▸ Restart your terminal for changes to take effect."
printf "${YELLOW}▸ " 
if [ "$LANGUAGE" = "es" ]; then
  printf "¿Deseas iniciar la configuración ahora? [s/n]: ${NC}"
else
  printf "Do you want to start the setup now? [y/n]: ${NC}"
fi
read RUN_CONFIG
if [[ "$RUN_CONFIG" =~ ^[sSyY]$ ]]; then
  "$BIN_DIR/meow-colorscripts-setup"
fi

print_msg "¡Miau! Instalación completada exitosamente." "Meow! Installation completed successfully."
chmod +x "$0"
