#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"
NAMES_FILE="$HOME/.config/meow-colorscripts/names.txt"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Detectar idioma configurado en install.sh
if [[ -f "$LANG_FILE" ]]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"  # Si no se encuentra, usa inglés por defecto
fi

# 🐾 Reiniciar configuración
if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
fi

# 🐾 Preguntar por el estilo
echo -e "${CYAN}󰄛 Elige tu estilo de meow-colorscripts:${NC}"
echo -e "1) ${WHITE}Normal${NC}"
echo -e "2) ${WHITE}Sin color${NC}"
echo -e "3) ${CYAN}Tema: Nord, Catpuccin, Everforest${NC}"
echo -e "4) ${GREEN}ASCII: Símbolos o Bloques${NC}"
read -p "Selecciona una opción [1-4]: " STYLE_OPTION

case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3) 
        echo -e "\n${CYAN}󰄛 ¿Qué tema quieres usar?${NC}"
        echo -e "1) ${GREEN}Nord${NC}"
        echo -e "2) ${CYAN}Catpuccin${NC}"
        echo -e "3) ${YELLOW}Everforest${NC}"
        read -p "Selecciona una opción [1-3]: " THEME_OPTION
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="normal" ;;
        esac
        ;;
    4) 
        echo -e "\n${CYAN}󰄛 ¿Qué tipo de ASCII prefieres?${NC}"
        echo -e "1) ${YELLOW}Símbolos de teclado${NC}"
        echo -e "2) ${RED}Bloques${NC}"
        read -p "Selecciona una opción [1-2]: " ASCII_TYPE_OPTION
        case "$ASCII_TYPE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        MEOW_THEME="ascii"
        ;;
    *) MEOW_THEME="normal" ;;
esac

# 🐾 Preguntar por el tamaño si no es ASCII
if [[ "$MEOW_THEME" != "ascii" ]]; then
    echo -e "\n${CYAN}󰄛 ¿Qué tamaño prefieres?${NC}"
    echo -e "1) ${GREEN}Pequeño${NC}"
    echo -e "2) ${WHITE}Normal${NC}"
    echo -e "3) ${RED}Grande${NC}"
    read -p "Selecciona una opción [1-3]: " SIZE_OPTION
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi

# 🐾 Activar comandos de nombres
echo -e "\n${CYAN}󰄛 ¿Quieres activar 'meows-names' y 'meows-show [name]'?${NC}"
echo -e "1) Sí"
echo -e "2) No"
read -p "Selecciona una opción [1-2]: " ENABLE_NAMES_OPTION

if [[ "$ENABLE_NAMES_OPTION" == "1" ]]; then
    ls "$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME/$MEOW_SIZE" | grep ".txt" | sed 's/.txt//' > "$NAMES_FILE"
    echo -e "${GREEN} Archivo de nombres generado correctamente: ${WHITE}$NAMES_FILE${NC}"
fi

# 🐾 Guardar configuración en meow.conf
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"

echo -e "\n${GREEN} Configuración guardada exitosamente.${NC}"
echo -e "📁 Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"

# 🐾 Preguntar si ejecutar ansi-meow al abrir la terminal
echo -e "\n${CYAN}󰄛 ¿Quieres ejecutar ansi-meow al abrir la terminal?${NC}"
echo -e "1) Sí"
echo -e "2) No"
read -p "Selecciona una opción [1-2]: " AUTO_RUN_OPTION

if [[ "$AUTO_RUN_OPTION" == "1" ]]; then
    USER_SHELL=$(basename "$SHELL")
    ALIAS_CMD="bash ~/.config/meow-colorscripts/show-meows.sh"

    case "$USER_SHELL" in
        "bash") echo "$ALIAS_CMD" >> "$HOME/.bashrc" ;;
        "zsh") echo "$ALIAS_CMD" >> "$HOME/.zshrc" ;;
        "fish") echo "$ALIAS_CMD" >> "$HOME/.config/fish/config.fish" ;;
    esac
    echo -e "${GREEN} ansi-meow ahora se ejecutará al abrir la terminal.${NC}"
fi
