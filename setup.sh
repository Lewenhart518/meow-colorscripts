#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"
NAMES_FILE="$HOME/.config/meow-colorscripts/names.txt"

# ────────────────────────────────────────────────────────────── 
# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Detectar idioma configurado en install.sh (default "en")
if [[ -f "$LANG_FILE" ]]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Eliminar alias duplicados
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
    echo -e "Duplicate aliases removed successfully."
else
    echo -e "Duplicate aliases removed successfully."
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Verificar si meow.conf existe y eliminarlo antes de configurarlo
if [[ -f "$CONFIG_FILE" ]]; then
    rm "$CONFIG_FILE"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "Removing previous configuration..."
    else
        echo -e "Removing previous configuration..."
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar por el estilo de meow-colorscripts
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${CYAN}Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}Sin color${NC}"
    echo -e "3) ${CYAN}Tema: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Símbolos o Bloques${NC}"
    read -p "Selecciona una opción [1-4]: " STYLE_OPTION
else
    echo -e "${CYAN}Choose your meow-colorscripts style:${NC}"
    echo -e "1) ${WHITE}Normal${NC}"
    echo -e "2) ${WHITE}No color${NC}"
    echo -e "3) ${CYAN}Theme: Nord, Catpuccin, Everforest${NC}"
    echo -e "4) ${GREEN}ASCII: Symbols or Blocks${NC}"
    read -p "Select an option [1-4]: " STYLE_OPTION
fi
# ────────────────────────────────────────────────────────────── 

case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3)
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tema quieres usar?${NC}"
            echo -e "1) ${GREEN}Nord${NC}"
            echo -e "2) ${CYAN}Catpuccin${NC}"
            echo -e "3) ${YELLOW}Everforest${NC}"
            read -p "Selecciona una opción [1-3]: " THEME_OPTION
        else
            echo -e "\n${CYAN}Which theme do you want to use?${NC}"
            echo -e "1) ${GREEN}Nord${NC}"
            echo -e "2) ${CYAN}Catpuccin${NC}"
            echo -e "3) ${YELLOW}Everforest${NC}"
            read -p "Select an option [1-3]: " THEME_OPTION
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
            echo -e "\n${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "2) ${RED}Bloques${NC}"
            read -p "Selecciona una opción [1-2]: " ASCII_TYPE_OPTION
        else
            echo -e "\n${CYAN}Which type of ASCII do you prefer?${NC}"
            echo -e "1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "2) ${RED}Blocks${NC}"
            read -p "Select an option [1-2]: " ASCII_TYPE_OPTION
        fi
        case "$ASCII_TYPE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        MEOW_THEME="ascii"
        ;;
    *) MEOW_THEME="normal" ;;
esac

# ────────────────────────────────────────────────────────────── 
# Preguntar por el tamaño si el estilo no es "ascii"
if [[ "$MEOW_THEME" != "ascii" ]]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
        echo -e "1) ${GREEN}Pequeño${NC}"
        echo -e "2) ${WHITE}Normal${NC}"
        echo -e "3) ${RED}Grande${NC}"
        read -p "Selecciona una opción [1-3]: " SIZE_OPTION
    else
        echo -e "\n${CYAN}What size do you prefer?${NC}"
        echo -e "1) ${GREEN}Small${NC}"
        echo -e "2) ${WHITE}Normal${NC}"
        echo -e "3) ${RED}Large${NC}"
        read -p "Select an option [1-3]: " SIZE_OPTION
    fi
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar si activar los comandos de meows-names y meows-show [name]
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${CYAN}¿Deseas activar los comandos 'meows-names' y 'meows-show [name]'?${NC}"
    echo -e "1) Sí"
    echo -e "2) No"
    read -p "Selecciona una opción [1-2]: " ENABLE_NAMES_OPTION
else
    echo -e "\n${CYAN}Do you want to activate the commands 'meows-names' and 'meows-show [name]'?${NC}"
    echo -e "1) Yes"
    echo -e "2) No"
    read -p "Select an option [1-2]: " ENABLE_NAMES_OPTION
fi

if [[ "$ENABLE_NAMES_OPTION" == "1" ]]; then
    # Se asume que los scripts en la carpeta colorscripts existen según la selección
    if [[ -d "$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME/$MEOW_SIZE" ]]; then
        ls "$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME/$MEOW_SIZE" | grep ".txt" | sed 's/\.txt//' > "$NAMES_FILE"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${GREEN}Archivo de nombres generado correctamente: ${WHITE}$NAMES_FILE${NC}"
        else
            echo -e "\n${GREEN}Names file generated successfully: ${WHITE}$NAMES_FILE${NC}"
        fi
    else
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${RED}No se encontró la carpeta de scripts de colores.${NC}"
        else
            echo -e "\n${RED}Colorscripts folder not found.${NC}"
        fi
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar si se desea ejecutar ansi-meow al abrir la terminal
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${CYAN}¿Deseas ejecutar ansi-meow al abrir la terminal?${NC}"
    echo -e "1) Sí"
    echo -e "2) No"
    read -p "Selecciona una opción [1-2]: " AUTO_RUN_OPTION
else
    echo -e "\n${CYAN}Do you want to run ansi-meow when the terminal starts?${NC}"
    echo -e "1) Yes"
    echo -e "2) No"
    read -p "Select an option [1-2]: " AUTO_RUN_OPTION
fi

if [[ "$AUTO_RUN_OPTION" == "1" ]]; then
    USER_SHELL=$(basename "$SHELL")
    AUTO_ALIAS_CMD="bash ~/.config/meow-colorscripts/show-meows.sh"
    case "$USER_SHELL" in
        "bash") echo "$AUTO_ALIAS_CMD" >> "$HOME/.bashrc" ;;
        "zsh") echo "$AUTO_ALIAS_CMD" >> "$HOME/.zshrc" ;;
        "fish")
            echo -e "function ansi-meow" >> "$HOME/.config/fish/config.fish"
            echo -e "    bash ~/.config/meow-colorscripts/show-meows.sh" >> "$HOME/.config/fish/config.fish"
            echo -e "end" >> "$HOME/.config/fish/config.fish"
            ;;
    esac
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "\n${GREEN}El alias se agregó correctamente. Debes reiniciar la terminal para que surta efecto.${NC}"
    else
        echo -e "\n${GREEN}Alias added successfully. Restart your terminal for the changes to take effect.${NC}"
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Guardar configuración
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${GREEN}Configuración guardada exitosamente.${NC}"
    echo -e "Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"
else
    echo -e "\n${GREEN}Configuration saved successfully.${NC}"
    echo -e "Configuration file: ${WHITE}$CONFIG_FILE${NC}"
fi
# ────────────────────────────────────────────────────────────── 
