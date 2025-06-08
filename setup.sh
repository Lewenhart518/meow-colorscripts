#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script te permite seleccionar el estilo y tamaño de meow-colorscripts.
# Según la elección, se utilizará un directorio en:
#   $HOME/.config/meow-colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
#
# Además, se pregunta si deseas activar los comandos de nombres.
# Si respondes que sí, se genera el archivo 'names.txt' con la lista de nombres
# (basado en los archivos .txt de ese directorio), que activará los comandos:
#    - meows-names
#    - meow-show [nombre]
# ========================================================

# Colores e íconos para mensajes
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# Si la variable LANGUAGE no está definida, se asume en español por defecto
if [ -z "$LANGUAGE" ]; then
    LANGUAGE="es"
fi

# ========================================================
# Selección de estilo
# ========================================================
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

# ========================================================
# Definir variables según la elección de estilo y tamaño
# ========================================================
MEOW_THEME=""
MEOW_SIZE=""

case "$STYLE_OPTION" in
    1)
        MEOW_THEME="normal"
        ;;
    2)
        MEOW_THEME="nocolor"
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
        ;;
    4)
        MEOW_THEME="ascii"
        ;;
    5)
        MEOW_THEME="ascii-color"
        ;;
    *)
        MEOW_THEME="normal"
        ;;
esac

# ========================================================
# Selección de tamaño
# ========================================================
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

# ========================================================
# Preguntar si se desean activar los comandos de nombres
# ========================================================
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ¿Deseas activar los comandos 'meows-names' y 'meow-show [nombre]'?"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " ENABLE_NAMES_OPTION
else
    echo -e "\n Do you want to activate the commands 'meows-names' and 'meow-show [name]'?"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " ENABLE_NAMES_OPTION
fi

if [[ "$LANGUAGE" == "es" ]]; then
    if [[ "$ENABLE_NAMES_OPTION" == "s" || "$ENABLE_NAMES_OPTION" == "S" ]]; then
        # Verificar que exista la carpeta del tema
        if [[ -d "$HOME/.config/meow-colorscripts/$MEOW_THEME" ]]; then
            SCRIPT_FOLDER="$HOME/.config/meow-colorscripts/$MEOW_THEME/$MEOW_SIZE"
            if [[ -d "$SCRIPT_FOLDER" ]]; then
                # Generar names.txt con los nombres (sin extensión) de los archivos .txt
                ls "$SCRIPT_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$HOME/.config/meow-colorscripts/names.txt"
                echo -e "\n ${GREEN}Archivo de nombres generado correctamente: ${WHITE}$HOME/.config/meow-colorscripts/names.txt${NC}"
            else
                echo -e "\n ${RED}Error: No se encontró la carpeta de scripts para la opción seleccionada.${NC}"
            fi
        else
            echo -e "\n ${RED}Error: No se encontró la carpeta de scripts para el tema '${MEOW_THEME}'.${NC}"
        fi
    else
        echo -e "\n ${YELLOW}No se activaron los comandos de nombres. Puedes activarlos más adelante ejecutando 'meow-colorscripts-setup'.${NC}"
    fi
else
    if [[ "$ENABLE_NAMES_OPTION" == "y" || "$ENABLE_NAMES_OPTION" == "Y" ]]; then
        if [[ -d "$HOME/.config/meow-colorscripts/$MEOW_THEME" ]]; then
            SCRIPT_FOLDER="$HOME/.config/meow-colorscripts/$MEOW_THEME/$MEOW_SIZE"
            if [[ -d "$SCRIPT_FOLDER" ]]; then
                ls "$SCRIPT_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$HOME/.config/meow-colorscripts/names.txt"
                echo -e "\n ${GREEN}Names file generated successfully: ${WHITE}$HOME/.config/meow-colorscripts/names.txt${NC}"
            else
                echo -e "\n ${RED}Error: Colorscripts folder for the selected option not found.${NC}"
            fi
        else
            echo -e "\n ${RED}Error: Colorscripts folder for theme '${MEOW_THEME}' not found.${NC}"
        fi
    else
        echo -e "\n ${YELLOW}Names commands not activated. You may activate them later by running 'meow-colorscripts-setup'.${NC}"
    fi
fi

# ========================================================
# Guardar la configuración en meow.conf (para que el instalador
# y otros comandos puedan utilizar los valores seleccionados)
# ========================================================
CONFIG_DIR="$HOME/.config/meow-colorscripts"
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_DIR/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_DIR/meow.conf"

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${GREEN}Configuración guardada exitosamente.${NC}"
    echo -e "Archivo de configuración: ${WHITE}$CONFIG_DIR/meow.conf${NC}"
else
    echo -e "\n ${GREEN}Configuration saved successfully.${NC}"
    echo -e "Configuration file: ${WHITE}$CONFIG_DIR/meow.conf${NC}"
fi
