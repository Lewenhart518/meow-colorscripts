#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script configura meow-colorscripts:
#
# • Permite elegir el idioma, estílo y tamaño/tipo.
# • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf
# • Guarda el idioma en ~/.config/meow-colorscripts/lang
# • Si se activa la opción de nombres, genera names.txt (solo con los nombres,
#   sin extensión) a partir de los archivos .txt en:
#       ~/.config/meow-colorscripts/colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
# • Muestra mensajes de “carga felina”.
# ========================================================

# Colores ANSI para mensajes
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

CONFIG_DIR="$HOME/.config/meow-colorscripts"
mkdir -p "$CONFIG_DIR"

# --- Determinar y solicitar idioma ---
LANG_FILE="$CONFIG_DIR/lang"
LANGUAGE="en"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

echo -e "${CYAN} Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
read -p "󰏩 Choose an option [1/2]: " LANG_OPTION
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
else
    LANGUAGE="en"
fi
echo "$LANGUAGE" > "$LANG_FILE"

# Función para imprimir mensajes según idioma
print_msg() {
    # Uso: print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

# --- Selección de estilo ---
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${CYAN} Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "  1) normal"
    echo -e "  2) nocolor"
    echo -e "  3) themes (nord, catpuccin, everforest)"
    echo -e "  4) ascii"
    echo -e "  5) ascii-color"
    read -p "󰏩 Selecciona una opción [1-5]: " STYLE_OPTION
else
    echo -e "${CYAN} Choose your meow-colorscripts style:${NC}"
    echo -e "  1) normal"
    echo -e "  2) nocolor"
    echo -e "  3) themes (nord, catpuccin, everforest)"
    echo -e "  4) ascii"
    echo -e "  5) ascii-color"
    read -p "󰏩 Select an option [1-5]: " STYLE_OPTION
fi

if [[ -z "$STYLE_OPTION" ]]; then
    STYLE_OPTION=1
fi

MEOW_THEME=""
case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3)
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n ¿Qué tema deseas usar?"
            echo -e "  1) nord"
            echo -e "  2) catpuccin"
            echo -e "  3) everforest"
            read -p "󰏩 Selecciona una opción [1-3]: " THEME_OPTION
        else
            echo -e "\n Which theme do you want to use?"
            echo -e "  1) nord"
            echo -e "  2) catpuccin"
            echo -e "  3) everforest"
            read -p "󰏩 Select an option [1-3]: " THEME_OPTION
        fi
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="nord" ;;
        esac
        ;;
    4) MEOW_THEME="ascii" ;;
    5) MEOW_THEME="ascii-color" ;;
    *) MEOW_THEME="normal" ;;
esac

# --- Selección de tamaño o tipo (para ascii/ascii-color, se pide tipo) ---
MEOW_SIZE=""
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "\n Selecciona el tipo de ASCII:"
        echo -e "  1) keyboard symbols"
        echo -e "  2) blocks"
        read -p "󰏩 Selecciona una opción [1-2]: " ASCII_OPTION
    else
        echo -e "\n Select the ASCII type:"
        echo -e "  1) keyboard symbols"
        echo -e "  2) blocks"
        read -p "󰏩 Select an option [1-2]: " ASCII_OPTION
    fi
    if [[ "$ASCII_OPTION" == "1" ]]; then
        MEOW_SIZE="keyboard-symbols"
    elif [[ "$ASCII_OPTION" == "2" ]]; then
        MEOW_SIZE="block"
    else
        MEOW_SIZE="keyboard-symbols"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "\n Selecciona el tamaño:"
        echo -e "  1) Small"
        echo -e "  2) Normal"
        echo -e "  3) Large"
        read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
    else
        echo -e "\n Select the size:"
        echo -e "  1) Small"
        echo -e "  2) Normal"
        echo -e "  3) Large"
        read -p "󰏩 Select an option [1-3]: " SIZE_OPTION
    fi
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi

echo -e "\n--------------------------------------------------------------------------------"
print_msg "Has seleccionado el estilo: ${GREEN}$MEOW_THEME${NC}\nY el tamaño/tipo: ${GREEN}$MEOW_SIZE${NC}" \
          "You have selected the style: ${GREEN}$MEOW_THEME${NC}\nAnd size/type: ${GREEN}$MEOW_SIZE${NC}"
echo -e "--------------------------------------------------------------------------------\n"

# --- Opcional: Activar comandos de nombres y generar names.txt ---
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

# La carpeta de arte se ubicará en:
# ~/.config/meow-colorscripts/colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
ART_FOLDER="$CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE"

if [[ "$ENABLE_NAMES_OPTION" =~ ^[sSyY]$ ]]; then
    if [ ! -d "$ART_FOLDER" ]; then
        mkdir -p "$ART_FOLDER"
        print_msg "\n${YELLOW} Advertencia: La carpeta para el arte no existía y se ha creado: $ART_FOLDER${NC}" \
                  "\n${YELLOW}Warning: Art folder did not exist and has been created: $ART_FOLDER${NC}"
    fi
    # Generar names.txt solo si existen archivos .txt en ART_FOLDER
    if ls "$ART_FOLDER"/*.txt &> /dev/null; then
        ls "$ART_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$CONFIG_DIR/names.txt"
        print_msg "\n ${GREEN}Archivo de nombres generado correctamente:${NC} ${WHITE}$CONFIG_DIR/names.txt${NC}" \
                  "\n ${GREEN}Names file generated successfully:${NC} ${WHITE}$CONFIG_DIR/names.txt${NC}"
    else
        print_msg "\n${YELLOW} Advertencia: No se encontraron archivos .txt en $ART_FOLDER.${NC}" \
                  "\n${YELLOW}Warning: No .txt files found in $ART_FOLDER.${NC}"
    fi
else
    print_msg "\n${YELLOW} Los comandos de nombres no se han activado.${NC}" \
              "\n${YELLOW}Names commands not activated.${NC}"
fi

# --- Frases de carga felinas ---
LOADING_MSGS_ES=("Los gatos se estiran" "Acomodando almohadillas" "Afinando maullidos" "Ronroneo en progreso" "Explorando el código")
LOADING_MSGS_EN=("The cats are stretching" "Adjusting paw pads" "Fine-tuning meows" "Purring in progress" "Exploring the code")
LOADING_USED=()
for i in {1..3}; do 
    while true; do
        if [[ "$LANGUAGE" == "es" ]]; then
            RANDOM_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
        else
            RANDOM_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
        fi
        if [[ ! " ${LOADING_USED[@]} " =~ " $RANDOM_MSG " ]]; then
            LOADING_USED+=("$RANDOM_MSG")
            break
        fi
    done
    echo -ne "${CYAN}$RANDOM_MSG"
    for j in {1..3}; do 
        echo -ne "."
        sleep 0.5
    done
    echo -e " ${GREEN}${NC}"
done

# --- Guardar la configuración en meow.conf ---
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_DIR/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_DIR/meow.conf"
print_msg "\n ${GREEN}Configuración guardada exitosamente.${NC}\nArchivo de configuración: ${WHITE}$CONFIG_DIR/meow.conf${NC}" \
          "\n ${GREEN}Configuration saved successfully.${NC}\nConfiguration file: ${WHITE}$CONFIG_DIR/meow.conf${NC}"
