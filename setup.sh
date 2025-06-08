#!/bin/bash
# ========================================================
# Setup de meow-colorscripts
# ========================================================
# Este script te permitirá configurar el estilo, tamaño y opciones
# de meow-colorscripts. Genera el archivo de nombres y activa los comandos
# "meows-names" y "show-meow [nombre]".
#
# Asegúrate de que la variable LANGUAGE esté definida (ej. "es" o "en").
# Si no, por defecto se usará "en".

# Colores para mensajes
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# Si LANGUAGE no está definido, se establece por defecto a "en"
if [ -z "$LANGUAGE" ]; then
    LANGUAGE="en"
fi

# ------------------------------------------------------------
# Selección de estilo
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e " ${CYAN}Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "  1) ${WHITE}normal${NC}"
    echo -e "  2) ${WHITE}nocolor${NC}"
    echo -e "  3) ${CYAN}temas (nord, catpuccin, everforest)${NC}"
    echo -e "  4) ${GREEN}ascii${NC}"
    echo -e "  5) ${GREEN}ascii-color${NC}"
    read -p "󰏩 Selecciona una opción [1-5]: " STYLE_OPTION
else
    echo -e " ${CYAN}Choose your meow-colorscripts style:${NC}"
    echo -e "  1) ${WHITE}normal${NC}"
    echo -e "  2) ${WHITE}nocolor${NC}"
    echo -e "  3) ${CYAN}themes (nord, catpuccin, everforest)${NC}"
    echo -e "  4) ${GREEN}ascii${NC}"
    echo -e "  5) ${GREEN}ascii-color${NC}"
    read -p "󰏩 Select an option [1-5]: " STYLE_OPTION
fi

# Inicializo variables
MEOW_THEME=""
MEOW_SIZE=""

case "$STYLE_OPTION" in
    1)
        MEOW_THEME="normal"
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
        ;;
    2)
        MEOW_THEME="nocolor"
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
        ;;
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
        ;;
    4)
        MEOW_THEME="ascii"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n ${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "  2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " SIZE_OPTION
        else
            echo -e "\n ${CYAN}Which type of ASCII do you prefer?${NC}"
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
            echo -e "\n ${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "  2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " SIZE_OPTION
        else
            echo -e "\n ${CYAN}Which type of ASCII do you prefer?${NC}"
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
        ;;
esac

# ------------------------------------------------------------
# Preguntar si se desean activar los comandos de nombres ("meows-names" y "show-meow [nombre]")
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ¿Deseas activar los comandos 'meows-names' y 'show-meow [nombre]'?"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " ENABLE_NAMES_OPTION
else
    echo -e "\n Do you want to activate the commands 'meows-names' and 'show-meow [name]'?"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " ENABLE_NAMES_OPTION
fi

if [[ "$LANGUAGE" == "es" ]]; then
    if [[ "$ENABLE_NAMES_OPTION" == "s" || "$ENABLE_NAMES_OPTION" == "S" ]]; then
        if [[ -d "$HOME/.config/meow-colorscripts/$MEOW_THEME" ]]; then
            SCRIPT_FOLDER="$HOME/.config/meow-colorscripts/$MEOW_THEME/$MEOW_SIZE"
            if [[ -d "$SCRIPT_FOLDER" ]]; then
                ls "$SCRIPT_FOLDER" | grep ".txt" | sed 's/\.txt//' > "$HOME/.config/meow-colorscripts/names.txt"
                echo -e "\n ${GREEN}Archivo de nombres generado correctamente: ${WHITE}$HOME/.config/meow-colorscripts/names.txt${NC}"
            else
                echo -e "\n ${RED}Error: No se encontró la carpeta de scripts para la opción seleccionada.${NC}"
            fi
        else
            echo -e "\n ${RED}Error: No se encontró la carpeta de scripts de colores.${NC}"
        fi
    fi
else
    if [[ "$ENABLE_NAMES_OPTION" == "y" || "$ENABLE_NAMES_OPTION" == "Y" ]]; then
        if [[ -d "$HOME/.config/meow-colorscripts/$MEOW_THEME" ]]; then
            SCRIPT_FOLDER="$HOME/.config/meow-colorscripts/$MEOW_THEME/$MEOW_SIZE"
            if [[ -d "$SCRIPT_FOLDER" ]]; then
                ls "$SCRIPT_FOLDER" | grep ".txt" | sed 's/\.txt//' > "$HOME/.config/meow-colorscripts/names.txt"
                echo -e "\n ${GREEN}Names file generated successfully: ${WHITE}$HOME/.config/meow-colorscripts/names.txt${NC}"
            else
                echo -e "\n ${RED}Error: Colorscripts folder for selected option not found.${NC}"
            fi
        else
            echo -e "\n ${RED}Error: Colorscripts folder not found.${NC}"
        fi
    fi
fi

# ------------------------------------------------------------
# Preguntar si se desea ejecutar meow-colorscripts al abrir la terminal (auto-run)
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ¿Deseas ejecutar meow-colorscripts al abrir la terminal?"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " AUTO_RUN_OPTION
else
    echo -e "\n Do you want to run meow-colorscripts when the terminal starts?"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " AUTO_RUN_OPTION
fi

if [[ "$LANGUAGE" == "es" ]]; then
    if [[ "$AUTO_RUN_OPTION" == "s" || "$AUTO_RUN_OPTION" == "S" ]]; then
        USER_SHELL=$(basename "$SHELL")
        AUTO_CMD="bash ~/.local/bin/meow-colorscripts"
        case "$USER_SHELL" in
            "bash") echo "$AUTO_CMD" >> "$HOME/.bashrc" ;;
            "zsh") echo "$AUTO_CMD" >> "$HOME/.zshrc" ;;
            "fish")
                echo -e "function meow-colorscripts" >> "$HOME/.config/fish/config.fish"
                echo -e "    bash ~/.local/bin/meow-colorscripts" >> "$HOME/.config/fish/config.fish"
                echo -e "end" >> "$HOME/.config/fish/config.fish"
                ;;
        esac
        echo -e "\n ${GREEN}Auto-run agregado correctamente. ${YELLOW} Recuerda: reinicia tu terminal para que surta efecto.${NC}"
    fi
else
    if [[ "$AUTO_RUN_OPTION" == "y" || "$AUTO_RUN_OPTION" == "Y" ]]; then
        USER_SHELL=$(basename "$SHELL")
        AUTO_CMD="bash ~/.local/bin/meow-colorscripts"
        case "$USER_SHELL" in
            "bash") echo "$AUTO_CMD" >> "$HOME/.bashrc" ;;
            "zsh") echo "$AUTO_CMD" >> "$HOME/.zshrc" ;;
            "fish")
                echo -e "function meow-colorscripts" >> "$HOME/.config/fish/config.fish"
                echo -e "    bash ~/.local/bin/meow-colorscripts" >> "$HOME/.config/fish/config.fish"
                echo -e "end" >> "$HOME/.config/fish/config.fish"
                ;;
        esac
        echo -e "\n ${GREEN}Auto-run added successfully. ${YELLOW} Remember: restart your terminal for the changes to take effect.${NC}"
    fi
fi

# ------------------------------------------------------------
# Guardar la configuración en meow.conf (dentro de ~/.config/meow-colorscripts)
echo "MEOW_THEME=$MEOW_THEME" > "$HOME/.config/meow-colorscripts/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$HOME/.config/meow-colorscripts/meow.conf"

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${GREEN}Configuración guardada exitosamente.${NC}"
    echo -e "Archivo de configuración: ${WHITE}$HOME/.config/meow-colorscripts/meow.conf${NC}"
else
    echo -e "\n ${GREEN}Configuration saved successfully.${NC}"
    echo -e "Configuration file: ${WHITE}$HOME/.config/meow-colorscripts/meow.conf${NC}"
fi

