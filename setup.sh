#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script configura meow-colorscripts:
#   • Lee el idioma a usar desde LANG (o del archivo ~/.config/meow-colorscripts/lang)
#   • Solicita al usuario que elija estilo y tamaño (o tipo en ascii/ascii-color)
#   • Pregunta si desea activar el autorun (para ejecutar meow-colorscripts al inicio)
#   • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf, incluyendo:
#         MEOW_THEME, MEOW_SIZE y MEOW_AUTORUN
#   • Si se activan los comandos de nombres, genera names.txt a 
#     partir de los .txt en ~/.config/meow-colorscripts/colorscripts/<MEOW_THEME>/<MEOW_SIZE>/,
#     y los instala en ~/.local/bin (`meows-names` y `meow-show`).
#   • Muestra mensajes de carga felina.
# ========================================================

# Colores ANSI para mensajes
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"

# Crear la carpeta de configuración si no existe
mkdir -p "$CONFIG_DIR"

# Obtener el idioma de LANG o del archivo lang
if [ -n "$LANG" ]; then
    LANGUAGE="$LANG"
elif [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

# Función para imprimir mensajes según idioma
print_msg() {
    # Uso: print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        printf "%b\n" "$1"
    else
        printf "%b\n" "$2"
    fi
}

# --------------------------------------------------------
# Selección de estilo
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    printf "%b\n" "${CYAN}Elige tu estilo de meow-colorscripts:${NC}"
    printf "%b\n" "  1) normal"
    printf "%b\n" "  2) nocolor"
    printf "%b\n" "  3) themes (nord, catpuccin, everforest)"
    printf "%b\n" "  4) ascii"
    printf "%b\n" "  5) ascii-color"
    read -p "Selecciona una opción [1-5]: " STYLE_OPTION
else
    printf "%b\n" "${CYAN}Choose your meow-colorscripts style:${NC}"
    printf "%b\n" "  1) normal"
    printf "%b\n" "  2) nocolor"
    printf "%b\n" "  3) themes (nord, catpuccin, everforest)"
    printf "%b\n" "  4) ascii"
    printf "%b\n" "  5) ascii-color"
    read -p "Select an option [1-5]: " STYLE_OPTION
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
            printf "\n%b\n" "¿Qué tema deseas usar?"
            printf "%b\n" "  1) nord"
            printf "%b\n" "  2) catpuccin"
            printf "%b\n" "  3) everforest"
            read -p "Selecciona una opción [1-3]: " THEME_OPTION
        else
            printf "\n%b\n" "Which theme do you want to use?"
            printf "%b\n" "  1) nord"
            printf "%b\n" "  2) catpuccin"
            printf "%b\n" "  3) everforest"
            read -p "Select an option [1-3]: " THEME_OPTION
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

# --------------------------------------------------------
# Selección de tamaño o tipo (para ascii/ascii-color se solicita el "tipo")
# --------------------------------------------------------
MEOW_SIZE=""
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "\n%b\n" "Selecciona el tipo de ASCII:"
        printf "%b\n" "  1) keyboard symbols"
        printf "%b\n" "  2) blocks"
        read -p "Selecciona una opción [1-2]: " ASCII_OPTION
    else
        printf "\n%b\n" "Select the ASCII type:"
        printf "%b\n" "  1) keyboard symbols"
        printf "%b\n" "  2) blocks"
        read -p "Select an option [1-2]: " ASCII_OPTION
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
        printf "\n%b\n" "Selecciona el tamaño:"
        printf "%b\n" "  1) Small"
        printf "%b\n" "  2) Normal"
        printf "%b\n" "  3) Large"
        read -p "Selecciona una opción [1-3]: " SIZE_OPTION
    else
        printf "\n%b\n" "Select the size:"
        printf "%b\n" "  1) Small"
        printf "%b\n" "  2) Normal"
        printf "%b\n" "  3) Large"
        read -p "Select an option [1-3]: " SIZE_OPTION
    fi
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi

# --------------------------------------------------------
# Activación de comandos de nombres (genera names.txt e instala `meows-names` y `meow-show`)
# --------------------------------------------------------
ART_FOLDER="$CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE"

if [[ -d "$ART_FOLDER" ]]; then
    ls "$ART_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$CONFIG_DIR/names.txt"
    print_msg "${GREEN}Archivo de nombres generado correctamente.${NC}" "${GREEN}Names file generated successfully.${NC}"
    install -Dm755 "$CONFIG_DIR/show-names.sh" "$BIN_DIR/meows-names"
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-show"
    print_msg "${GREEN}Comandos 'meows-names' y 'meow-show' instalados correctamente.${NC}" "${GREEN}'meows-names' and 'meow-show' installed successfully.${NC}"
fi

# --------------------------------------------------------
# Guardar la configuración en meow.conf
# --------------------------------------------------------
echo "MEOW_THEME=$MEOW_THEME" > "$MEOW_CONF"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$MEOW_CONF"

print_msg "${GREEN}Configuración guardada exitosamente.${NC}" "${GREEN}Configuration saved successfully.${NC}"
