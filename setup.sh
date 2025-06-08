#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Detectar idioma desde install.sh
LANGUAGE="en"
if [[ -f "$LANG_FILE" ]]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# 🐾 Reiniciar configuración
if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
fi

# 🐾 Preguntar por el estilo
if [[ "$LANGUAGE" == "en" ]]; then
    echo -e "${CYAN}󰄛 Choose your meow-colorscripts style:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}No color${NC}"
    echo -e "3) ${CYAN}Theme: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Symbols or Blocks${NC}"
else
    echo -e "${CYAN}󰄛 ¿Qué estilo de meow-colorscripts quieres usar?${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}Sin color${NC}"
    echo -e "3) ${CYAN}Tema: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Símbolos o Bloques${NC}"
fi
read -p "Selecciona una opción [1-4]: " STYLE_OPTION

case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3) 
        if [[ "$LANGUAGE" == "en" ]]; then
            echo -e "\n${CYAN}󰄛 Choose your theme:${NC}"
            echo -e "1) ${GREEN}Nord${NC}"
            echo -e "2) ${CYAN}Catpuccin${NC}"
            echo -e "3) ${YELLOW}Everforest${NC}"
        else
            echo -e "\n${CYAN}󰄛 ¿Qué tema quieres usar?${NC}"
            echo -e "1) ${GREEN}Nord${NC}"
            echo -e "2) ${CYAN}Catpuccin${NC}"
            echo -e "3) ${YELLOW}Everforest${NC}"
        fi
        read -p "Selecciona una opción [1-3]: " THEME_OPTION
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="normal" ;;
        esac
        ;;
    4) 
        if [[ "$LANGUAGE" == "en" ]]; then
            echo -e "\n${CYAN}󰄛 Do you want ASCII with color or without?${NC}"
            echo -e "1) ${GREEN}With color${NC}"
            echo -e "2) ${WHITE}Without color${NC}"
        else
            echo -e "\n${CYAN}󰄛 ¿Quieres ASCII con color o sin color?${NC}"
            echo -e "1) ${GREEN}Con color${NC}"
            echo -e "2) ${WHITE}Sin color${NC}"
        fi
        read -p "Selecciona una opción [1-2]: " ASCII_OPTION
        case "$ASCII_OPTION" in
            1) MEOW_THEME="ascii-color" ;;
            2) MEOW_THEME="ascii" ;;
            *) MEOW_THEME="ascii" ;;
        esac

        if [[ "$LANGUAGE" == "en" ]]; then
            echo -e "\n${CYAN}󰄛 Which ASCII style do you prefer?${NC}"
            echo -e "1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "2) ${RED}Blocks${NC}"
        else
            echo -e "\n${CYAN}󰄛 ¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "2) ${RED}Bloques${NC}"
        fi
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
    if [[ "$LANGUAGE" == "en" ]]; then
        echo -e "\n${CYAN}󰄛 Choose the size:${NC}"
        echo -e "1) ${GREEN}Small${NC}"
        echo -e "2) ${WHITE}Normal${NC}"
        echo -e "3) ${RED}Large${NC}"
    else
        echo -e "\n${CYAN}󰄛 ¿Qué tamaño prefieres?${NC}"
        echo -e "1) ${GREEN}Pequeño${NC}"
        echo -e "2) ${WHITE}Normal${NC}"
        echo -e "3) ${RED}Grande${NC}"
    fi
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
