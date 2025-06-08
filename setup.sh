#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script configura el comportamiento de meow-colorscripts:
#
#   • Permite elegir el estilo:
#         1) normal
#         2) nocolor
#         3) themes (nord, catpuccin, everforest)
#         4) ascii
#         5) ascii-color
#
#   • Según el estilo seleccionado, se pregunta por:
#         - Tamaño: small, normal, large (para estilos distintos a ascii)
#         - Tipo: keyboard symbols o block (para ascii o ascii-color)
#
#   • Opcionalmente, se pregunta si se activan los comandos de nombres,
#     que generan el archivo names.txt basado en los archivos .txt en:
#         $HOME/.config/meow-colorscripts/<MEOW_THEME>/<MEOW_SIZE>
#
#   • Se guardan las variables en:
#         $HOME/.config/meow-colorscripts/meow.conf
# ========================================================

# ---------------------------
# Colores ANSI (para terminal compatible)
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'
# ---------------------------

# ========================================================
# Determinar idioma (leer archivo lang; por defecto "en")
# ========================================================
CONFIG_DIR="$HOME/.config/meow-colorscripts"
mkdir -p "$CONFIG_DIR"
LANGUAGE="en"
LANG_FILE="$CONFIG_DIR/lang"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para imprimir mensajes según idioma
print_msg() {
  # Uso: print_msg "mensaje en español" "message in English"
  if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "$1"
  else
    echo -e "$2"
  fi
}

# ========================================================
# Selección de estilo
# ========================================================
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

# Si la entrada está vacía se asigna por defecto 1 ("normal")
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
            *) MEOW_THEME="nord" ;;  # Valor por defecto
        esac
        ;;
    4) MEOW_THEME="ascii" ;;
    5) MEOW_THEME="ascii-color" ;;
    *) MEOW_THEME="normal" ;;
esac

# ========================================================
# Selección de tamaño o tipo según estilo
# ========================================================
MEOW_SIZE=""
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
    # Para ascii/ascii-color preguntamos por tipo
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "\n Selecciona el tipo de ASCII:"
        echo -e "  1) Keyboard symbols"
        echo -e "  2) Blocks"
        read -p "󰏩 Selecciona una opción [1-2]: " ASCII_OPTION
    else
        echo -e "\n Select the ASCII type:"
        echo -e "  1) Keyboard symbols"
        echo -e "  2) Blocks"
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
    # Para otros estilos, se pregunta por tamaño
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

# Mostrar confirmación de selección.
echo -e "\n--------------------------------------------------------------------------------"
print_msg "Has seleccionado el estilo: ${GREEN}$MEOW_THEME${NC}\nY el tamaño/tipo: ${GREEN}$MEOW_SIZE${NC}" \
          "You have selected the style: ${GREEN}$MEOW_THEME${NC}\nAnd size/type: ${GREEN}$MEOW_SIZE${NC}"
echo -e "--------------------------------------------------------------------------------\n"

# ========================================================
# Activación de comandos de nombres (opcional)
# ========================================================
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

# Ruta para el arte (usada para generar el archivo names.txt)
ART_FOLDER="$CONFIG_DIR/$MEOW_THEME/$MEOW_SIZE"

# Si se activa y si la carpeta no existe, la creamos para evitar error
if [[ "$ENABLE_NAMES_OPTION" =~ ^[sSyY]$ ]]; then
    if [ ! -d "$ART_FOLDER" ]; then
        mkdir -p "$ART_FOLDER"
        print_msg "\n${YELLOW} Advertencia: La carpeta para el arte no existía y se ha creado: $ART_FOLDER${NC}" \
                  "\n${YELLOW}Warning: Art folder did not exist and has been created: $ART_FOLDER${NC}"
    fi
    # Comprobar si hay archivos .txt; si no, se muestra una advertencia y no se genera names.txt
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
              "\n${YELLOW} Names commands not activated.${NC}"
fi

# ========================================================
# Mostrar mensajes de carga felina (3 mensajes aleatorios)
# ========================================================
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

# ========================================================
# Guardar la configuración en meow.conf
# ========================================================
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_DIR/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_DIR/meow.conf"

print_msg "\n ${GREEN}Configuración guardada exitosamente.${NC}\nArchivo de configuración: ${WHITE}$CONFIG_DIR/meow.conf${NC}" \
          "\n ${GREEN}Configuration saved successfully.${NC}\nConfiguration file: ${WHITE}$CONFIG_DIR/meow.conf${NC}"
