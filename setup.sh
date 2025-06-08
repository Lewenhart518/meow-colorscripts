#!/bin/bash

# Variables de configuración
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
# Iconos usados:
#   -> Encabezado o título
# 󰏩 -> Prompt de entrada
#   -> Pregunta o instrucción adicional
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Detectar idioma (ya configurado en install.sh)
if [[ -f "$LANG_FILE" ]]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar por el estilo de meow-colorscripts
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e " ${CYAN}Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "  1) ${WHITE}normal${NC}"
    echo -e "  2) ${WHITE}nocolor${NC}"
    echo -e "  3) ${CYAN}temas (nord, catpuccin, everforest)${NC}"
    echo -e "  4) ${GREEN}ascii${NC}"
    echo -e "  5) ${GREEN}ascii-color${NC}"
    read -p "󰏩 Selecciona una opción [1-5]: " STYLE_OPTION
else
    echo -e " ${CYAN}Choose your meow-colorscripts style:${NC}"
    echo -e "  1) ${WHITE}normal${NC}"
    echo -e "  2) ${WHITE}nocolor${NC}"
    echo -e "  3) ${CYAN}themes (nord, catpuccin, everforest)${NC}"
    echo -e "  4) ${GREEN}ascii${NC}"
    echo -e "  5) ${GREEN}ascii-color${NC}"
    read -p "󰏩 Select an option [1-5]: " STYLE_OPTION
fi
# ────────────────────────────────────────────────────────────── 

case "$STYLE_OPTION" in
    1)
        MEOW_THEME="normal"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
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
        ;;
    2)
        MEOW_THEME="nocolor"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
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
        ;;
    3)
        # Sección "temas" para elegir entre: nord, catpuccin, everforest
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tema deseas usar?${NC}"
            echo -e "  1) ${CYAN}nord${NC}"
            echo -e "  2) ${CYAN}catpuccin${NC}"
            echo -e "  3) ${CYAN}everforest${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " THEME_OPTION
        else
            echo -e "\n${CYAN}Which theme do you want to use?${NC}"
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
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
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
        ;;
    4)
        MEOW_THEME="ascii"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "  2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}Which type of ASCII do you prefer?${NC}"
            echo -e "  1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "  2) ${RED}Blocks${NC}"
            read -p "󰏩 Select an option [1-2]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        ;;
    5)
        MEOW_THEME="ascii-color"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "  2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}Which type of ASCII do you prefer?${NC}"
            echo -e "  1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "  2) ${RED}Blocks${NC}"
            read -p "󰏩 Select an option [1-2]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        ;;
    *)
        MEOW_THEME="normal"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
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
        ;;
esac
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar si activar los comandos 'meows-names' y 'show-meow [name]'
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${CYAN} ¿Deseas activar los comandos 'meows-names' y 'show-meow [name]'?${NC}"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " ENABLE_NAMES_OPTION
else
    echo -e "\n${CYAN} Do you want to activate the commands 'meows-names' and 'show-meow [name]'?${NC}"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " ENABLE_NAMES_OPTION
fi

if [[ "$LANGUAGE" == "es" ]]; then
    if [[ "$ENABLE_NAMES_OPTION" == "s" || "$ENABLE_NAMES_OPTION" == "S" ]]; then
        if [[ -d "$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME" ]]; then
            SCRIPT_FOLDER="$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME/$MEOW_SIZE"
            if [[ -d "$SCRIPT_FOLDER" ]]; then
                ls "$SCRIPT_FOLDER" | grep ".txt" | sed 's/\.txt//' > "$NAMES_FILE"
                echo -e "\n${GREEN} Archivo de nombres generado correctamente: ${WHITE}$NAMES_FILE${NC}"
                alias meows-names="cat $NAMES_FILE"
                alias show-meow="grep -i"
            else
                echo -e "\n${RED}󰀅 Error: No se encontró la carpeta de scripts para la opción seleccionada.${NC}"
            fi
        else
            echo -e "\n${RED}󰀅 Error: No se encontró la carpeta de scripts de colores.${NC}"
        fi
    fi
else
    if [[ "$ENABLE_NAMES_OPTION" == "y" || "$ENABLE_NAMES_OPTION" == "Y" ]]; then
        if [[ -d "$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME" ]]; then
            SCRIPT_FOLDER="$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME/$MEOW_SIZE"
            if [[ -d "$SCRIPT_FOLDER" ]]; then
                ls "$SCRIPT_FOLDER" | grep ".txt" | sed 's/\.txt//' > "$NAMES_FILE"
                echo -e "\n${GREEN} Names file generated successfully: ${WHITE}$NAMES_FILE${NC}"
                alias meows-names="cat $NAMES_FILE"
                alias show-meow="grep -i"
            else
                echo -e "\n${RED}󰀅 Error: Colorscripts folder for selected option not found.${NC}"
            fi
        else
            echo -e "\n${RED}󰀅 Error: Colorscripts folder not found.${NC}"
        fi
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar si se desea ejecutar ansi-meow al abrir la terminal (auto-run)
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${CYAN} ¿Deseas ejecutar ansi-meow al abrir la terminal?${NC}"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " AUTO_RUN_OPTION
else
    echo -e "\n${CYAN} Do you want to run ansi-meow when the terminal starts?${NC}"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " AUTO_RUN_OPTION
fi

if [[ "$LANGUAGE" == "es" ]]; then
    if [[ "$AUTO_RUN_OPTION" == "s" || "$AUTO_RUN_OPTION" == "S" ]]; then
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
        echo -e "\n${GREEN} Alias agregado correctamente. ${YELLOW} Debes reiniciar la terminal para que surta efecto.${NC}"
    fi
else
    if [[ "$AUTO_RUN_OPTION" == "y" || "$AUTO_RUN_OPTION" == "Y" ]]; then
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
        echo -e "\n${GREEN} Alias added successfully. ${YELLOW} You must restart your terminal for the alias to work.${NC}"
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Guardar configuración
if [[ "$MEOW_THEME" == "ascii" || "$MEOW_THEME" == "ascii-color" ]]; then
    echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
    echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"
else
    echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
    echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"
fi

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${GREEN} Configuración guardada exitosamente.${NC}"
    echo -e "Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"
else
    echo -e "\n${GREEN} Configuration saved successfully.${NC}"
    echo -e "Configuration file: ${WHITE}$CONFIG_FILE${NC}"
fi
# ────────────────────────────────────────────────────────────── 

