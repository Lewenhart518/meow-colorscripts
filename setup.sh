#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts (Versión MiauNord)
# ========================================================
# Este script configura meow-colorscripts:
# • Carga el idioma (usando LANG o ~/.config/meow-colorscripts/lang; "en" por defecto)
# • Permite seleccionar el estilo y el tamaño o tipo (para ASCII)
# • Si se selecciona "themes", pregunta por el tema (nord, catpuccin, everforest)
# • Muestra un resumen de la configuración elegida
# • Pregunta si se desean activar los comandos:
#       - meow-colorscripts-names (que muestra el contenido de names.txt)
#       - meow-colorscripts-show (para mostrar arte ASCII específico)
# • Pregunta si activar autorun (añadiendo "meow-colorscripts" al inicio de la terminal)
# • Pregunta si se desea activar el comando meow-fact (moviendo y renombrando su script de ~/meow-colorscripts a ~/.local/bin/meow-fact)
# • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf
# ========================================================

# --- Definición de colores ANSI (paleta Nord) ---
GREEN="\033[38;2;143;188;187m"       # NORD7 – verde/acento
RED="\033[38;2;59;66;82m"              # NORD1 – gris oscuro (para errores)
YELLOW="\033[38;2;129;161;193m"        # NORD9 – azul claro (acento)
CYAN="\033[38;2;136;192;208m"          # NORD8 – cian/acento
MAGENTA="\033[38;2;94;129;172m"         # NORD10 – azul oscuro
BLUE="\033[38;2;65;105;225m"            # Azul para prompts
WHITE="\033[38;2;216;222;233m"          # NORD4 – texto claro
NC="\033[0m"                          # Reset

# --- Directorios y rutas ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$HOME/meow-colorscripts"

# Aseguramos que exista la carpeta de configuración
mkdir -p "$CONFIG_DIR"

# --- Detección del idioma ---
if [ -n "$LANG" ]; then
  LANGUAGE="$LANG"
elif [ -f "$LANG_FILE" ]; then
  LANGUAGE=$(cat "$LANG_FILE")
else
  LANGUAGE="en"
fi

# Función para imprimir mensajes según el idioma
print_msg() {
  # Uso: print_msg "mensaje en español" "message in English"
  if [ "$LANGUAGE" = "es" ]; then
    printf "%b\n" "$1"
  else
    printf "%b\n" "$2"
  fi
}

# Función para mostrar mensajes dinámicos
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

# ----------------------------------------------------
# 1. Seleccionar el estilo de meow-colorscripts
# ----------------------------------------------------
while true; do
  if [ "$LANGUAGE" = "es" ]; then
    printf "%b\n" "${CYAN}▸ Elige tu estilo de meow-colorscripts:${NC}"
    printf "%b\n" "  ${YELLOW}1) normal${NC}"
    printf "%b\n" "  ${YELLOW}2) nocolor${NC}"
    printf "%b\n" "  ${YELLOW}3) themes${NC}"
    printf "%b\n" "  ${YELLOW}4) ascii${NC}"
    printf "%b\n" "  ${YELLOW}5) ascii-color${NC}"
    printf "%b" "${BLUE}▸ Selecciona una opción [1-5]: ${NC}"
    read STYLE_OPTION
  else
    printf "%b\n" "${CYAN}▸ Choose your meow-colorscripts style:${NC}"
    printf "%b\n" "  ${YELLOW}1) normal${NC}"
    printf "%b\n" "  ${YELLOW}2) nocolor${NC}"
    printf "%b\n" "  ${YELLOW}3) themes (nord, catpuccin, everforest)${NC}"
    printf "%b\n" "  ${YELLOW}4) ascii${NC}"
    printf "%b\n" "  ${YELLOW}5) ascii-color${NC}"
    printf "%b" "${BLUE}▸ Select an option [1-5]: ${NC}"
    read STYLE_OPTION
  fi

  if [[ ! "$STYLE_OPTION" =~ ^[1-5]$ ]]; then
    printf "%b\n" "${RED}Opción inválida. Intenta nuevamente.${NC}"
    sleep 1
    clear
  else
    break  # Salir del bucle si la selección es válida.
  fi
done

# ----------------------------------------------------
# 2. Seleccionar el tema si se elige "themes" (opción 3)
# ----------------------------------------------------
if [ "$STYLE_OPTION" -eq 3 ]; then
  while true; do
    if [ "$LANGUAGE" = "es" ]; then
      printf "\n%b\n" "${CYAN}▸ ¿Qué tema deseas usar?${NC}"
      printf "%b\n" "  ${YELLOW}1) nord${NC}"
      printf "%b\n" "  ${YELLOW}2) catpuccin${NC}"
      printf "%b\n" "  ${YELLOW}3) everforest${NC}"
      printf "%b\n" "  ${RED}q) Regresar a la selección de estilos${NC}"
      printf "%b" "${BLUE}▸ Selecciona una opción [1-3/q]: ${NC}"
      read THEME_OPTION
    else
      printf "\n%b\n" "${CYAN}▸ Which theme do you want?${NC}"
      printf "%b\n" "  ${YELLOW}1) nord${NC}"
      printf "%b\n" "  ${YELLOW}2) catpuccin${NC}"
      printf "%b\n" "  ${YELLOW}3) everforest${NC}"
      printf "%b\n" "  ${RED}q) Return to style selection${NC}"
      printf "%b" "${BLUE}▸ Select an option [1-3/q]: ${NC}"
      read THEME_OPTION
    fi

    if [ "$THEME_OPTION" = "q" ]; then
      clear
      continue  # Regresa a la selección de estilo.
    elif [[ ! "$THEME_OPTION" =~ ^[1-3]$ ]]; then
      printf "%b\n" "${RED}Opción inválida. Intenta nuevamente.${NC}"
      sleep 1
      clear
    else
      break
    fi
  done

  case "$THEME_OPTION" in
    1) MEOW_THEME="nord" ;;
    2) MEOW_THEME="catpuccin" ;;
    3) MEOW_THEME="everforest" ;;
    *) MEOW_THEME="nord" ;;  # Por defecto
  esac
else
  case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    4) MEOW_THEME="ascii" ;;
    5) MEOW_THEME="ascii-color" ;;
    *) MEOW_THEME="normal" ;;
  esac
fi

# ----------------------------------------------------
# 3. Seleccionar el tamaño o tipo
# ----------------------------------------------------
if [ "$STYLE_OPTION" -eq 4 ] || [ "$STYLE_OPTION" -eq 5 ]; then
  while true; do
    if [ "$LANGUAGE" = "es" ]; then
      printf "\n%b\n" "${CYAN}▸ Selecciona el tipo de ASCII:${NC}"
      printf "%b\n" "  ${YELLOW}1) keyboard symbols${NC}"
      printf "%b\n" "  ${YELLOW}2) blocks${NC}"
      printf "%b\n" "  ${RED}q) Regresar a la selección de estilos${NC}"
      printf "%b" "${BLUE}▸ Selecciona una opción [1-2/q]: ${NC}"
      read ASCII_OPTION
    else
      printf "\n%b\n" "${CYAN}▸ Select the ASCII type:${NC}"
      printf "%b\n" "  ${YELLOW}1) keyboard symbols${NC}"
      printf "%b\n" "  ${YELLOW}2) blocks${NC}"
      printf "%b\n" "  ${RED}q) Return to style selection${NC}"
      printf "%b" "${BLUE}▸ Select an option [1-2/q]: ${NC}"
      read ASCII_OPTION
    fi

    if [ "$ASCII_OPTION" = "q" ]; then
      clear
      continue  # Regresa a la selección de estilo.
    elif [[ ! "$ASCII_OPTION" =~ ^[1-2]$ ]]; then
      printf "%b\n" "${RED}Opción inválida. Intenta nuevamente.${NC}"
      sleep 1
      clear
    else
      break
    fi
  done

  case "$ASCII_OPTION" in
    1) MEOW_SIZE="keyboard-symbols" ;;
    2) MEOW_SIZE="blocks" ;;
    *) MEOW_SIZE="keyboard-symbols" ;;
  esac
else
  if [ "$LANGUAGE" = "es" ]; then
    printf "\n%b\n" "${CYAN}▸ Selecciona el tamaño:${NC}"
    printf "%b\n" "  ${YELLOW}1) Small${NC}"
    printf "%b\n" "  ${YELLOW}2) Normal${NC}"
    printf "%b\n" "  ${YELLOW}3) Large${NC}"
    printf "%b" "${BLUE}▸ Selecciona una opción [1-3]: ${NC}"
    read SIZE_OPTION
  else
    printf "\n%b\n" "${CYAN}▸ Select the size:${NC}"
    printf "%b\n" "  ${YELLOW}1) Small${NC}"
    printf "%b\n" "  ${YELLOW}2) Normal${NC}"
    printf "%b\n" "  ${YELLOW}3) Large${NC}"
    printf "%b" "${BLUE}▸ Select an option [1-3]: ${NC}"
    read SIZE_OPTION
  fi

  case "$SIZE_OPTION" in
    1) MEOW_SIZE="small" ;;
    2) MEOW_SIZE="normal" ;;
    3) MEOW_SIZE="large" ;;
    *) MEOW_SIZE="normal" ;;
  esac
fi

# ----------------------------------------------------
# 4. Resumen de la configuración
# ----------------------------------------------------
printf "\n--------------------------------------------------------\n"
print_msg "Has seleccionado el estilo: ${GREEN}$MEOW_THEME${NC} y el tamaño/tipo: ${GREEN}$MEOW_SIZE${NC}" \
          "You have selected the style: ${GREEN}$MEOW_THEME${NC} and size/type: ${GREEN}$MEOW_SIZE${NC}"
printf "--------------------------------------------------------\n\n"

# ----------------------------------------------------
# 5. Guardar la configuración en meow.conf
# ----------------------------------------------------
{
  echo "export MEOW_THEME=\"$MEOW_THEME\""
  echo "export MEOW_SIZE=\"$MEOW_SIZE\""
} > "$MEOW_CONF"
printf "%b\n" "${GREEN}▸ La configuración se guardó en $MEOW_CONF${NC}"

# ----------------------------------------------------
# 6. Activar comandos adicionales (names y show)
# ----------------------------------------------------
if [ "$LANGUAGE" = "es" ]; then
  printf "%b\n" "${CYAN}▸ ¿Deseas activar los comandos 'meow-colorscripts-names' y 'meow-colorscripts-show [nombre]'?${NC}"
  printf "%b\n" "  ${YELLOW}s) Sí${NC}"
  printf "%b\n" "  ${YELLOW}n) No${NC}"
  printf "%b" "${BLUE}▸ Selecciona una opción [s/n]: ${NC}"
  read COMANDOS_OPTION
else
  printf "%b\n" "${CYAN}▸ Do you want to activate the commands 'meow-colorscripts-names' and 'meow-colorscripts-show [name]'?${NC}"
  printf "%b\n" "  ${YELLOW}y) Yes${NC}"
  printf "%b\n" "  ${YELLOW}n) No${NC}"
  printf "%b" "${BLUE}▸ Select an option [y/n]: ${NC}"
  read COMANDOS_OPTION
fi

if [[ "$COMANDOS_OPTION" =~ ^[sSyY]$ ]]; then
  if [ -f "$CONFIG_DIR/names.txt" ]; then
    print_msg "${GREEN}Archivo 'names.txt' encontrado en la configuración.${NC}" "${GREEN}'names.txt' found in configuration.${NC}"
  else
    print_msg "${RED}No se encontró 'names.txt' en la configuración.${NC}" "${RED}'names.txt' not found in configuration.${NC}"
  fi
  installed_commands=()
  {
    echo "#!/bin/bash"
    echo "cat $CONFIG_DIR/names.txt"
  } > "$HOME/.local/bin/meow-colorscripts-names"
  chmod +x "$HOME/.local/bin/meow-colorscripts-names"
  installed_commands+=( "meow-colorscripts-names" )
  
  if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$HOME/.local/bin/meow-colorscripts-show"
    installed_commands+=( "meow-colorscripts-show" )
  elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$HOME/.local/bin/meow-colorscripts-show"
    installed_commands+=( "meow-colorscripts-show" )
  else
    print_msg "${RED}No se encontró 'meow-colorscripts-show.sh'.${NC}" "${RED}'meow-colorscripts-show.sh' not found.${NC}"
  fi
  if [ ${#installed_commands[@]} -gt 0 ]; then
    print_msg "${GREEN}Comando(s) ${installed_commands[*]} instalado(s) correctamente.${NC}" \
              "${GREEN}Command(s) ${installed_commands[*]} installed successfully.${NC}"
  fi
fi

# ----------------------------------------------------
# 7. Autorun: activar el comando al iniciar la terminal
# ----------------------------------------------------
if [ "$LANGUAGE" = "es" ]; then
  printf "\n%b\n" "${CYAN}▸ ¿Deseas activar el autorun de meow-colorscripts al iniciar la terminal?${NC}"
  printf "%b\n" "  ${YELLOW}s) Sí${NC}"
  printf "%b\n" "  ${YELLOW}n) No${NC}"
  printf "%b" "${BLUE}▸ Selecciona una opción [s/n]: ${NC}"
  read AUTORUN_OPTION
else
  printf "\n%b\n" "${CYAN}▸ Do you want to enable autorun for meow-colorscripts on terminal startup?${NC}"
  printf "%b\n" "  ${YELLOW}y) Yes${NC}"
  printf "%b\n" "  ${YELLOW}n) No${NC}"
  printf "%b" "${BLUE}▸ Select an option [y/n]: ${NC}"
  read AUTORUN_OPTION
fi

if [[ "$AUTORUN_OPTION" =~ ^[sSyY]$ ]]; then
  MEOW_AUTORUN="true"
  CURRENT_SHELL=$(basename "$SHELL")
  case "$CURRENT_SHELL" in
    fish)
      SHELL_CONFIG="$HOME/.config/fish/config.fish"
      grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
      ;;
    bash)
      SHELL_CONFIG="$HOME/.bashrc"
      grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
      ;;
    zsh)
      SHELL_CONFIG="$HOME/.zshrc"
      grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
      ;;
    *)
      SHELL_CONFIG="$HOME/.profile"
      grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
      ;;
  esac
  print_msg "${GREEN}Autorun activado.${NC}" "${GREEN}Autorun enabled.${NC}"
else
  MEOW_AUTORUN="false"
fi

# ----------------------------------------------------
# 8. Activación del comando meow-fact
# ----------------------------------------------------
# Aseguramos que ~/.local/bin exista
mkdir -p "$HOME/.local/bin"

if [ "$LANGUAGE" = "es" ]; then
  printf "\n%b\n" "${CYAN}▸ ¿Deseas activar el comando meow-fact? (s/n): ${NC}"
  printf "%b\n" "  ${YELLOW}s) Sí${NC}"
  printf "%b\n" "  ${YELLOW}n) No${NC}"
else
  printf "\n%b\n" "${CYAN}▸ Do you want to activate the meow-fact command? (y/n): ${NC}"
  printf "%b\n" "  ${YELLOW}y) Yes${NC}"
  printf "%b\n" "  ${YELLOW}n) No${NC}"
fi

read activate_response

if [[ "$activate_response" =~ ^(s|S|y|Y)$ ]]; then
  # Buscar el archivo en dos posibles nombres:
  if [ -f "$HOME/meow-colorscripts/meow-fact.sh" ]; then
    TARGET="$HOME/meow-colorscripts/meow-fact.sh"
  elif [ -f "$HOME/meow-colorscripts/meow-fact" ]; then
    TARGET="$HOME/meow-colorscripts/meow-fact"
  else
    TARGET=""
  fi

  if [ -n "$TARGET" ]; then
    mv "$TARGET" "$HOME/.local/bin/meow-fact"
    chmod +x "$HOME/.local/bin/meow-fact"  # Asegurar que sea ejecutable
    if [ "$LANGUAGE" = "es" ]; then
      printf "%b\n" "${GREEN}▸ El comando meow-fact ha sido activado exitosamente.${NC}"
    else
      printf "%b\n" "${GREEN}▸ The meow-fact command has been successfully activated.${NC}"
    fi
  else
    if [ "$LANGUAGE" = "es" ]; then
      printf "%b\n" "${RED}▸ No se encontró ni 'meow-fact.sh' ni 'meow-fact' en ~/meow-colorscripts.${NC}"
    else
      printf "%b\n" "${RED}▸ Could not find 'meow-fact.sh' or 'meow-fact' in ~/meow-colorscripts.${NC}"
    fi
  fi
else
  if [ "$LANGUAGE" = "es" ]; then
    printf "%b\n" "${YELLOW}▸ El comando meow-fact no se activará.${NC}"
  else
    printf "%b\n" "${YELLOW}▸ The meow-fact command will not be activated.${NC}"
  fi
fi

# ----------------------------------------------------
# 9. Mensaje final y guardar la configuración
# ----------------------------------------------------
printf "\n%b\n" "${YELLOW} Recuerda: usa 'meow-colorscripts-show' para ver arte específico y 'meow-colorscripts-names' para consultar nombres.${NC}"
printf "%b\n" "${YELLOW} Reinicia tu terminal para que los cambios surtan efecto.${NC}"
printf "\n%b\n" "${MAGENTA}¡Miau! Configuración guardada exitosamente.${NC}\n"

# Guardar la configuración en meow.conf (incluyendo el valor de autorun)
{
  echo "export MEOW_THEME=\"$MEOW_THEME\""
  echo "export MEOW_SIZE=\"$MEOW_SIZE\""
  echo "export MEOW_AUTORUN=\"$MEOW_AUTORUN\""
} > "$MEOW_CONF"
