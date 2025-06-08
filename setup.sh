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

# 🐾  Detectar idioma configurado en install.sh
if [[ -f "$LANG_FILE" ]]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

# 🐾  Reiniciar configuración
if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
fi

# 🐾 󰄛 Preguntar por el estilo
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${CYAN}󰄛 Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}Sin color${NC}"
    echo -e "3) ${CYAN}Tema: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Símbolos o Bloques${NC}"
    read -p "󰏩 Selecciona una opción [1-4]: " STYLE_OPTION
else
    echo -e "${CYAN}󰄛 Choose your meow-colorscripts style:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}No color${NC}"
    echo -e "3) ${CYAN}Theme: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Symbols or Blocks${NC}"
    read -p "󰏩 Select an option [1-4]: " STYLE_OPTION
fi

case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3) 
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN} ¿Qué tema quieres usar?${NC}"
            echo -e "1) ${GREEN}Nord${NC}"
            echo -e "2) ${CYAN}Catpuccin${NC}"
            echo -e "3) ${YELLOW}Everforest${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " THEME_OPTION
        else
            echo -e "\n${CYAN} Which theme do you want to use?${NC}"
            echo -e "1) ${GREEN}Nord${NC}"
            echo -e "2) ${CYAN}Catpuccin${NC}"
            echo -e "3) ${YELLOW}Everforest${NC}"
            read -p "󰏩 Select an option [1-3]: " THEME_OPTION
        fi
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="normal" ;;
        esac
        ;;
    4) 
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN} ¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " ASCII_TYPE_OPTION
        else
            echo -e "\n${CYAN} Which type of ASCII do you prefer?${NC}"
            echo -e "1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "2) ${RED}Blocks${NC}"
            read -p "󰏩 Select an option [1-2]: " ASCII_TYPE_OPTION
        fi
        case "$ASCII_TYPE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        MEOW_THEME="ascii"
        ;;
    *) MEOW_THEME="normal" ;;
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

# 🐾  Detectar idioma configurado en install.sh
if [[ -f "$LANG_FILE" ]]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

# 🐾 󰄛 Eliminar alias duplicados
USER_SHELL=$(basename "$SHELL")
ALIAS_CMD="alias ansi-meow='bash ~/.config/meow-colorscripts/show-meows.sh'"

if [[ "$USER_SHELL" == "bash" ]]; then
    sed -i '/alias ansi-meow=/d' "$HOME/.bashrc"
elif [[ "$USER_SHELL" == "zsh" ]]; then
    sed -i '/alias ansi-meow=/d' "$HOME/.zshrc"
elif [[ "$USER_SHELL" == "fish" ]]; then
    sed -i '/function ansi-meow/d' "$HOME/.config/fish/config.fish"
fi

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${GREEN} Alias duplicados eliminados correctamente.${NC}"
else
    echo -e "${GREEN} Duplicate aliases removed successfully.${NC}"
fi

# 🐾 󰄛 Verificar si `meow.conf` existe y eliminarlo antes de configurarlo
if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Eliminando configuración previa...${NC}"
    else
        echo -e "${RED} Removing previous configuration...${NC}"
    fi
fi

# 🐾 󰏩 Preguntar por el estilo
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${CYAN}󰄛 Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}Sin color${NC}"
    echo -e "3) ${CYAN}Tema: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Símbolos o Bloques${NC}"
    read -p "󰏩 Selecciona una opción [1-4]: " STYLE_OPTION
else
    echo -e "${CYAN}󰄛 Choose your meow-colorscripts style:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}No color${NC}"
    echo -e "3) ${CYAN}Theme: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Symbols or Blocks${NC}"
    read -p "󰏩 Select an option [1-4]: " STYLE_OPTION
fi

case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3) 
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN} ¿Qué tema quieres usar?${NC}"
        else
            echo -e "\n${CYAN} Which theme do you want to use?${NC}"
        fi
        echo -e "1) ${GREEN}Nord${NC}"
        echo -e "2) ${CYAN}Catpuccin${NC}"
        echo -e "3) ${YELLOW}Everforest${NC}"
        read -p "󰏩 Select an option [1-3]: " THEME_OPTION
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="normal" ;;
        esac
        ;;
    4) 
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN} ¿Qué tipo de ASCII prefieres?${NC}"
        else
            echo -e "\n${CYAN} Which type of ASCII do you prefer?${NC}"
        fi
        echo -e "1) ${YELLOW}Símbolos de teclado${NC}"
        echo -e "2) ${RED}Bloques${NC}"
        read -p "󰏩 Select an option [1-2]: " ASCII_TYPE_OPTION
        case "$ASCII_TYPE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        MEOW_THEME="ascii"
        ;;
    *) MEOW_THEME="normal" ;;
esac

# 🐾 󰏩 Guardar configuración
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${GREEN} Configuración guardada exitosamente.${NC}"
    echo -e "󰚝 Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"
else
    echo -e "\n${GREEN} Configuration saved successfully.${NC}"
    echo -e "󰚝 Configuration file: ${WHITE}$CONFIG_FILE${NC}"
fi
