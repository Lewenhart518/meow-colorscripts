#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script configura el comportamiento de meow-colorscripts:
#
#   • Permite elegir el estilo:
#         - normal
#         - nocolor
#         - temas (nord, catpuccin, everforest)
#         - ascii
#         - ascii-color
#
#   • Según el estilo seleccionado, se pregunta por:
#         - Tamaño: small, normal, large (para estilos distintos a ASCII)
#         - Tipo: "keyboard-symbols" o "block" (para ascii o ascii-color)
#
#   • Opcionalmente, se pregunta si se activan los comandos de nombres,
#     generando el archivo names.txt que se basa en los archivos .txt en la
#     carpeta $HOME/.config/meow-colorscripts/<MEOW_THEME>/<MEOW_SIZE>
#
#   • Se guarda la configuración en: $HOME/.config/meow-colorscripts/meow.conf
# ========================================================

# --- Colores ANSI para mensajes (suponiendo terminal compatible)
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# ========================================================
# Detectar idioma configurado (leer archivo lang si existe)
# ========================================================
LANGUAGE="en"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para imprimir mensajes según idioma
print_msg() {
  # print_msg "es" "Mensaje en español" "Message in English"
  if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "$2"
  else
    echo -e "$3"
  fi
}

# ========================================================
# Selección de estilo (menú)
# ========================================================
if [[ "$LANGUAGE" == "es" ]]; then
  echo -e "${CYAN} Elige tu estilo de meow-colorscripts:${NC}"
  echo -e "  1) ${WHITE}normal${NC}"
  echo -e "  2) ${WHITE}nocolor${NC}"
  echo -e "  3) ${CYAN}temas (nord, catpuccin, everforest)${NC}"
  echo -e "  4) ${GREEN}ascii${NC}"
  echo -e "  5) ${GREEN}ascii-color${NC}"
  read -p "󰏩 Selecciona una opción [1-5]: " STYLE_OPTION
else
  echo -e "${CYAN} Choose your meow-colorscripts style:${NC}"
  echo -e "  1) ${WHITE}normal${NC}"
  echo -e "  2) ${WHITE}nocolor${NC}"
  echo -e "  3) ${CYAN}themes (nord, catpuccin, everforest)${NC}"
  echo -e "  4) ${GREEN}ascii${NC}"
  echo -e "  5) ${GREEN}ascii-color${NC}"
  read -p "󰏩 Select an option [1-5]: " STYLE_OPTION
fi

MEOW_THEME=""
case "$STYLE_OPTION" in
  1) MEOW_THEME="normal" ;;
  2) MEOW_THEME="nocolor" ;;
  3)
    if [[ "$LANGUAGE" == "es" ]]; then
      echo -e "\n ${CYAN}¿Qué tema deseas usar?${NC}"
      echo -e "  1) ${CYAN}nord${NC}"
      echo -e "  2) ${CYAN}catpuccin${NC}"
      echo -e "  3) ${CYAN}everforest${NC}"
      read -p "󰏩 Selecciona una opción [1-3]: " THEME_OPTION
    else
      echo -e "\n ${CYAN}Which theme do you want to use?${NC}"
      echo -e "  1) ${CYAN}nord${NC}"
      echo -e "  2) ${CYAN}catpuccin${NC}"
      echo -e "  3) ${CYAN}everforest${NC}"
      read -p "󰏩 Select an option [1-3]: " THEME_OPTION
    fi
    case "$THEME_OPTION" in
      1) MEOW_THEME="nord" ;;
      2) MEOW_THEME="catpuccin" ;;
      3) MEOW_THEME="everforest" ;;
      *) MEOW_THEME="nord" ;;
    esac
    ;;
  4) MEOW_THEME="ascii" ;;
  5) MEOW_THEME="ascii-color" ;;
  *) MEOW_THEME="normal" ;;
esac

# ========================================================
# Selección de tamaño o tipo (dependiendo del estilo)
# ========================================================
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
  # Para ascii y ascii-color, en vez de tamaño se pregunta tipo.
  if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
    echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
    echo -e "  2) ${RED}Bloques${NC}"
    read -p "󰏩 Selecciona una opción [1-2]: " ASCII_OPTION
  else
    echo -e "\n ${CYAN}Which type of ASCII do you prefer?${NC}"
    echo -e "  1) ${YELLOW}Keyboard symbols${NC}"
    echo -e "  2) ${RED}Blocks${NC}"
    read -p "󰏩 Select an option [1-2]: " ASCII_OPTION
  fi
  case "$ASCII_OPTION" in
    1) MEOW_SIZE="keyboard-symbols" ;;
    2) MEOW_SIZE="block" ;;
    *) MEOW_SIZE="keyboard-symbols" ;;
  esac
else
  # Para otros estilos se pregunta por tamaño (small/normal/large)
  if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${CYAN}¿Qué tamaño prefieres?${NC}"
    echo -e "  1) ${GREEN}Pequeño${NC}"
    echo -e "  2) ${WHITE}Normal${NC}"
    echo -e "  3) ${RED}Grande${NC}"
    read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
  else
    echo -e "\n ${CYAN}What size do you prefer?${NC}"
    echo -e "  1) ${GREEN}Small${NC}"
    echo -e "  2) ${WHITE}Normal${NC}"
    echo -e "  3) ${RED}Large${NC}"
    read -p "󰏩 Select an option [1-3]: " SIZE_OPTION
  fi
  case "$SIZE_OPTION" in
    1) MEOW_SIZE="small" ;;
    2) MEOW_SIZE="normal" ;;
    3) MEOW_SIZE="large" ;;
    *) MEOW_SIZE="normal" ;;
  esac
fi

# ========================================================
# Preguntar si se desean activar los comandos de nombres
# ========================================================
if [[ "$LANGUAGE" == "es" ]]; then
  echo -e "\n ${CYAN}¿Deseas activar los comandos 'meows-names' y 'meow-show [nombre]'?${NC}"
  echo -e "  s) Sí"
  echo -e "  n) No"
  read -p "󰏩 Selecciona una opción [s/n]: " ENABLE_NAMES_OPTION
else
  echo -e "\n ${CYAN}Do you want to activate the commands 'meows-names' and 'meow-show [name]'?${NC}"
  echo -e "  y) Yes"
  echo -e "  n) No"
  read -p "󰏩 Select an option [y/n]: " ENABLE_NAMES_OPTION
fi

# Si se desea activar, se genera el archivo names.txt
if [[ "$ENABLE_NAMES_OPTION" == "s" || "$ENABLE_NAMES_OPTION" == "S" || "$ENABLE_NAMES_OPTION" == "y" || "$ENABLE_NAMES_OPTION" == "Y" ]]; then
  NAMES_FOLDER="$HOME/.config/meow-colorscripts/$MEOW_THEME/$MEOW_SIZE"
  if [ -d "$NAMES_FOLDER" ]; then
    ls "$NAMES_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$HOME/.config/meow-colorscripts/names.txt"
    print_msg "$LANGUAGE" \
      "\n ${GREEN}Archivo de nombres generado correctamente:${NC} ${WHITE}$HOME/.config/meow-colorscripts/names.txt${NC}" \
      "\n ${GREEN}Names file generated successfully:${NC} ${WHITE}$HOME/.config/meow-colorscripts/names.txt${NC}"
  else
    print_msg "$LANGUAGE" \
      "\n${RED} Error: No se encontró la carpeta para el tema/tipo seleccionado.${NC}" \
      "\n${RED} Error: Art folder for the selected option not found.${NC}"
  fi
else
  print_msg "$LANGUAGE" \
    "\n${YELLOW} No se activaron los comandos de nombres. Puedes activarlos luego con 'meow-colorscripts-setup'.${NC}" \
    "\n${YELLOW} Names commands not activated. You may enable them later by running 'meow-colorscripts-setup'.${NC}"
fi

# ========================================================
# Guardar la configuración en meow.conf
# ========================================================
CONFIG_DIR="$HOME/.config/meow-colorscripts"
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_DIR/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_DIR/meow.conf"

print_msg "$LANGUAGE" \
  "\n ${GREEN}Configuración guardada exitosamente.${NC}\nArchivo de configuración: ${WHITE}$CONFIG_DIR/meow.conf${NC}" \
  "\n ${GREEN}Configuration saved successfully.${NC}\nConfiguration file: ${WHITE}$CONFIG_DIR/meow.conf${NC}"

