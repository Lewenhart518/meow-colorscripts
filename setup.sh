#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Preguntar por el tema
echo -e "${CYAN}󰄛 ¿Qué tema de ansi-meow quieres usar?${NC}"
echo -e "1) ${GREEN}Nord${NC}"
echo -e "2) ${CYAN}Catpuccin${NC}"
echo -e "3) ${YELLOW}Everforest${NC}"
echo -e "4) ${WHITE}Sin color (nocolor)${NC}"
echo -e "5) ${RED}Normal${NC}"
echo -e "6) ${GREEN}ASCII${NC}"
read -p "Selecciona una opción [1-6]: " THEME_OPTION

case "$THEME_OPTION" in
    1) MEOW_THEME="nord" ;;
    2) MEOW_THEME="catpuccin" ;;
    3) MEOW_THEME="everforest" ;;
    4) MEOW_THEME="nocolor" ;;
    5) MEOW_THEME="normal" ;;
    6) 
        echo -e "\n${CYAN}󰄛 ¿Quieres ASCII con color o sin color?${NC}"
        echo -e "1) ${GREEN}Con color (ascii-color)${NC}"
        echo -e "2) ${WHITE}Sin color (ascii)${NC}"
        read -p "Selecciona una opción [1-2]: " ASCII_OPTION
        case "$ASCII_OPTION" in
            1) MEOW_THEME="ascii-color" ;;
            2) MEOW_THEME="ascii" ;;
            *) MEOW_THEME="ascii" ;;
        esac

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
    *) MEOW_THEME="normal" ;;
esac

# 🐾 Preguntar por el tamaño si no es ASCII
if [[ "$MEOW_THEME" != "ascii" && "$MEOW_THEME" != "ascii-color" ]]; then
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
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"

echo -e "\n${GREEN} Configuración guardada exitosamente.${NC}"
echo -e "📁 Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"

# 🐾 Preguntar si se quiere ejecutar ansi-meow al abrir la terminal
echo -e "\n${CYAN}󰄛 ¿Quieres que ansi-meow se ejecute al abrir la terminal?${NC}"
echo -e "1) Sí"
echo -e "2) No"
read -p "Selecciona una opción [1-2]: " AUTO_RUN_OPTION

if [ "$AUTO_RUN_OPTION" == "1" ]; then
    echo -e "\n${GREEN} Añadiendo ansi-meow al inicio de la terminal.${NC}"
    echo "bash ~/.config/meow-colorscripts/show-meows.sh" >> "$HOME/.bashrc"
    echo -e "${WHITE}📁 Se ha actualizado ~/.bashrc.${NC}"
fi
