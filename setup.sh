#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Preguntar por el tipo de configuración
echo -e "${CYAN}󰄛 ¿Cómo quieres ver los meows?${NC}"
echo -e "1) Tema (${GREEN}Nord, Catpuccin, Everforest${NC})"
echo -e "2) Normal"
echo -e "3) Sin color"
echo -e "4) ASCII"
read -p "Selecciona una opción [1-4]: " TYPE_OPTION

# 🐾 Determinar tipo según opción elegida
case "$TYPE_OPTION" in
    1) 
        echo -e "\n${CYAN}󰄛 ¿Qué tema prefieres?${NC}"
        echo -e "1) ${GREEN}Nord${NC}"
        echo -e "2) ${CYAN}Catpuccin${NC}"
        echo -e "3) ${YELLOW}Everforest${NC}"
        read -p "Selecciona una opción [1-3]: " THEME_OPTION
        case "$THEME_OPTION" in
            1) MEOW_TYPE="nord" ;;
            2) MEOW_TYPE="catpuccin" ;;
            3) MEOW_TYPE="everforest" ;;
            *) MEOW_TYPE="nord" ;;
        esac
        ;;
    2) MEOW_TYPE="normal" ;;
    3) MEOW_TYPE="nocolor" ;;
    4) 
        echo -e "\n${CYAN}󰄛 ¿Quieres ASCII con color o sin color?${NC}"
        echo -e "1) ${GREEN}Con color (ascii-color)${NC}"
        echo -e "2) ${WHITE}Sin color (ascii)${NC}"
        read -p "Selecciona una opción [1-2]: " ASCII_OPTION
        if [ "$ASCII_OPTION" == "1" ]; then
            MEOW_TYPE="ascii-color"
        else
            MEOW_TYPE="ascii"
        fi
        echo -e "\n${CYAN}󰄛 ¿Qué tipo de ASCII prefieres?${NC}"
        echo -e "1) ${YELLOW}Símbolos de teclado (keyboard-symbols)${NC}"
        echo -e "2) ${RED}Bloques (block)${NC}"
        read -p "Selecciona una opción [1-2]: " ASCII_TYPE_OPTION
        case "$ASCII_TYPE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        ;;
    *) MEOW_TYPE="normal" ;;
esac

# 🐾 Si se seleccionó un tema, normal o sin color, preguntar por el tamaño
if [[ "$MEOW_TYPE" != "ascii" && "$MEOW_TYPE" != "ascii-color" ]]; then
    echo -e "\n${CYAN}󰄛 ¿Qué tamaño prefieres?${NC}"
    echo -e "1) ${GREEN}Pequeño (small)${NC}"
    echo -e "2) ${WHITE}Normal${NC}"
    echo -e "3) ${RED}Grande (large)${NC}"
    read -p "Selecciona una opción [1-3]: " SIZE_OPTION
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi

# 🐾 Guardar configuración en meow.conf
echo "MEOW_TYPE=$MEOW_TYPE" > "$CONFIG_FILE"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"

echo -e "\n${GREEN} Configuración guardada exitosamente.${NC}"
echo -e "📁 Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"
