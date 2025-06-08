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
CONFIG_DIR="$HOME/.config/meow-colorscripts"
LANG_FILE="$CONFIG_DIR/lang"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para imprimir mensajes según idioma
print_msg() {
  # Uso: print_msg "Mensaje en español" "Message in English"
  if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "$1"
  else
    echo -e "$2"
  fi
}

# Asegurarse de que la carpeta de configuración existe
mkdir -p "$CONFIG_DIR"

# ========================================================
# Selección de estilo
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

# Si no se ingresa nada o se ingresa algo inválido, se asigna por defecto "normal"
if [[ -z "$STYLE_OPTION" ]]; then
    STYLE_OPTION=1
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
            *) MEOW_THEME="nord" ;;  # Valor por defecto
        esac
        ;;
    4) MEOW_THEME="ascii" ;;
    5) MEOW_THEME="ascii-color" ;;
    *) MEOW_THEME="normal" ;;
esac

# ========================================================
# Selección de tamaño o tipo según el estilo
# ========================================================
MEOW_SIZE=""
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
    # Para ascii y ascii-color, en vez de tamaño se pregunta por tipo
    if [[ "$LANGUAGE" == "es" ]]; then
        read -p $'\n Selecciona el tipo de ASCII (1: Símbolos de teclado, 2: Bloques): ' ASCII_OPTION
    else
        read -p $'\n Select the ASCII type (1: Keyboard symbols, 2: Blocks): ' ASCII_OPTION
    fi
    if [[ "$ASCII_OPTION" == "1" ]]; then
        MEOW_SIZE="keyboard-symbols"
    elif [[ "$ASCII_OPTION" == "2" ]]; then
        MEOW_SIZE="block"
    else
        MEOW_SIZE="keyboard-symbols"
    fi
else
    # Para otros estilos se pregunta por tamaño (small, normal, large)
    if [[ "$LANGUAGE" == "es" ]]; then
        read -p $'\n Selecciona el tamaño (1: Pequeño, 2: Normal, 3: Grande): ' SIZE_OPTION
    else
        read -p $'\n Select the size (1: Small, 2: Normal, 3: Large): ' SIZE_OPTION
    fi
    if [[ "$SIZE_OPTION" == "1" ]]; then
        MEOW_SIZE="small"
    elif [[ "$SIZE_OPTION" == "2" ]]; then
        MEOW_SIZE="normal"
    elif [[ "$SIZE_OPTION" == "3" ]]; then
        MEOW_SIZE="large"
    else
        MEOW_SIZE="normal"
    fi
fi

# Mostrar los valores seleccionados para confirmar
echo -e "\n--------------------------------------------------------------------------------"
print_msg "Has seleccionado el estilo: ${GREEN}$MEOW_THEME${NC}\nY el tamaño/tipo: ${GREEN}$MEOW_SIZE${NC}" \
          "You have selected the style: ${GREEN}$MEOW_THEME${NC}\nAnd size/type: ${GREEN}$MEOW_SIZE${NC}"
echo -e "--------------------------------------------------------------------------------\n"

# ========================================================
# Preguntar sobre activación de comandos de nombres
# ========================================================
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${CYAN} ¿Deseas activar los comandos 'meows-names' y 'meow-show [nombre]'?${NC}"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " ENABLE_NAMES_OPTION
else
    echo -e "${CYAN} Do you want to activate the commands 'meows-names' and 'meow-show [name]'?${NC}"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " ENABLE_NAMES_OPTION
fi

if [[ "$ENABLE_NAMES_OPTION" == "s" || "$ENABLE_NAMES_OPTION" == "S" || "$ENABLE_NAMES_OPTION" == "y" || "$ENABLE_NAMES_OPTION" == "Y" ]]; then
    NAMES_FOLDER="$CONFIG_DIR/$MEOW_THEME/$MEOW_SIZE"
    if [ -d "$NAMES_FOLDER" ]; then
        ls "$NAMES_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$CONFIG_DIR/names.txt"
        print_msg "\n ${GREEN}Archivo de nombres generado correctamente:${NC} ${WHITE}$CONFIG_DIR/names.txt${NC}" \
                  "\n ${GREEN}Names file generated successfully:${NC} ${WHITE}$CONFIG_DIR/names.txt${NC}"
    else
        print_msg "\n${RED} Error: No se encontró la carpeta para el tema/tipo seleccionado.${NC}" \
                  "\n${RED} Error: Art folder for the selected option not found.${NC}"
    fi
else
    print_msg "\n${YELLOW} No se activaron los comandos de nombres. Puedes activarlos luego con 'meow-colorscripts-setup'.${NC}" \
              "\n${YELLOW} Names commands not activated. You may enable them later by running 'meow-colorscripts-setup'.${NC}"
fi

# ========================================================
# Guardar la configuración en meow.conf
# ========================================================
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_DIR/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_DIR/meow.conf"

print_msg "\n ${GREEN}Configuración guardada exitosamente.${NC}\nArchivo de configuración: ${WHITE}$CONFIG_DIR/meow.conf${NC}" \
          "\n ${GREEN}Configuration saved successfully.${NC}\nConfiguration file: ${WHITE}$CONFIG_DIR/meow.conf${NC}"
