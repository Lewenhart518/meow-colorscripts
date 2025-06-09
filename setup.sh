#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts (versión felina)
# ========================================================
# Este script configura meow-colorscripts:
# • Detecta el idioma (usando LANG o ~/.config/meow-colorscripts/lang,
#   por defecto "en").
# • Solicita al usuario que elija estilo y tamaño (o tipo, para ascii/ascii-color).
# • Pregunta si se desean activar los comandos:
#       - Se asume que el archivo "names.txt" ya forma parte del repositorio
#         y se encuentra en ~/.config/meow-colorscripts/names.txt.
#       - Instala "meow-colorscripts-names", que al ejecutarse muestra
#         el contenido de names.txt.
#       - Instala "meow-colorscripts-show" usando el archivo "meow-colorscripts-show.sh".
#         Se busca primero en ~/.config/meow-colorscripts; si no se encuentra,
#         se revisa en ~/meow-colorscripts.
# • Pregunta si se desea activar el autorun para que se ejecute "meow-colorscripts"
#   al inicio (se añade la línea exacta sin "&" ni comentarios en el archivo de la shell).
# • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf con las variables:
#         MEOW_THEME, MEOW_SIZE y MEOW_AUTORUN.
# • Muestra mensajes felinos dinámicos (por ejemplo, "PATH miauctuaizado") y,
#   al final, en amarillo, recuerda que se pueden usar los comandos y preguntar si se desea iniciar la configuración.
# ========================================================

# --- Definición de colores ANSI ---
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[1;33m'  # Amarillo brillante
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# --- Directorios y archivos ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"

# Asegurar la existencia de la carpeta de configuración
mkdir -p "$CONFIG_DIR"

# --- Detección del idioma ---
if [ -n "$LANG" ]; then
    LANGUAGE="$LANG"
elif [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

# Función para imprimir mensajes según idioma
print_msg() {
    if [ "$LANGUAGE" = "es" ]; then
        printf "%b\n" "$1"
    else
        printf "%b\n" "$2"
    fi
}

# Función para mostrar mensajes dinámicos (con icono de verificación)
print_dynamic_message() {
    local message="$1"
    local delay=0.3
    printf "%b" "$message"
    for i in {1..3}; do
         printf "."
         sleep $delay
    done
    printf " %b\n" "${GREEN}${NC}"
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
# Selección de tamaño o tipo
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

printf "\n--------------------------------------------------------\n"
print_msg "Has seleccionado el estilo: ${GREEN}$MEOW_THEME${NC} y el tamaño/tipo: ${GREEN}$MEOW_SIZE${NC}" \
          "You have selected the style: ${GREEN}$MEOW_THEME${NC} and size/type: ${GREEN}$MEOW_SIZE${NC}"
printf "--------------------------------------------------------\n\n"

# --------------------------------------------------------
# Preguntar si se desean activar los comandos de nombres y show
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    printf "%b\n" "${CYAN}¿Deseas activar los comandos 'meow-colorscripts-names' y 'meow-colorscripts-show [nombre]'?${NC}"
    printf "%b\n" "  s) Sí"
    printf "%b\n" "  n) No"
    read -p "Selecciona una opción [s/n]: " COMANDOS_OPTION
else
    printf "%b\n" "${CYAN}Do you want to activate the commands 'meow-colorscripts-names' and 'meow-colorscripts-show [name]'?${NC}"
    printf "%b\n" "  y) Yes"
    printf "%b\n" "  n) No"
    read -p "Select an option [y/n]: " COMANDOS_OPTION
fi

if [[ "$COMANDOS_OPTION" =~ ^[sS]|[yY]$ ]]; then
    # Verificar y notificar existencia del archivo names.txt
    if [ -f "$CONFIG_DIR/names.txt" ]; then
        print_msg "${GREEN}Archivo 'names.txt' encontrado en la configuración.${NC}" \
                  "${GREEN}'names.txt' found in configuration.${NC}"
    else
        print_msg "${YELLOW}No se encontró el archivo 'names.txt' en la configuración.${NC}" \
                  "${YELLOW}'names.txt' not found in configuration.${NC}"
    fi
    installed_commands=()
    # Instalar comando "meow-colorscripts-names" (muestra el contenido de names.txt)
    echo "#!/bin/bash" > "$BIN_DIR/meow-colorscripts-names"
    echo "cat $CONFIG_DIR/names.txt" >> "$BIN_DIR/meow-colorscripts-names"
    chmod +x "$BIN_DIR/meow-colorscripts-names"
    installed_commands+=( "meow-colorscripts-names" )
    
    # Instalar comando "meow-colorscripts-show"
    if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
        install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
        installed_commands+=( "meow-colorscripts-show" )
    elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
        install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
        installed_commands+=( "meow-colorscripts-show" )
    else
        print_msg "${YELLOW}No se encontró 'meow-colorscripts-show.sh'.${NC}" \
                  "${YELLOW}'meow-colorscripts-show.sh' not found.${NC}"
    fi
    
    if [ ${#installed_commands[@]} -gt 0 ]; then
        print_msg "${GREEN}Comando(s) ${installed_commands[*]} instalado(s) correctamente.${NC}" \
                  "${GREEN}Command(s) ${installed_commands[*]} installed successfully.${NC}"
    fi
fi

# --------------------------------------------------------
# Preguntar por autorun y actualizar el archivo de configuración de la shell
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    printf "\n%b\n" "${CYAN}¿Deseas activar el autorun de meow-colorscripts al iniciar la terminal?${NC}"
    printf "%b\n" "  s) Sí"
    printf "%b\n" "  n) No"
    read -p "Selecciona una opción [s/n]: " AUTORUN_OPTION
else
    printf "\n%b\n" "${CYAN}Do you want to enable autorun for meow-colorscripts on terminal startup?${NC}"
    printf "%b\n" "  y) Yes"
    printf "%b\n" "  n) No"
    read -p "Select an option [y/n]: " AUTORUN_OPTION
fi

if [[ "$AUTORUN_OPTION" =~ ^[sS]|[yY]$ ]]; then
    MEOW_AUTORUN="true"
    CURRENT_SHELL=$(basename "$SHELL")
    case "$CURRENT_SHELL" in
        fish)
            SHELL_CONFIG="$HOME/.config/fish/config.fish"
            grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
            ;;
        bash)
            SHELL_CONFIG="$HOME/.bashrc"
            grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
            ;;
        zsh)
            SHELL_CONFIG="$HOME/.zshrc"
            grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
            ;;
        *)
            SHELL_CONFIG="$HOME/.profile"
            grep -q "^meow-colorscripts" "$SHELL_CONFIG" || echo "meow-colorscripts" >> "$SHELL_CONFIG"
            ;;
    esac
    print_msg "${GREEN}Autorun activado.${NC}" "${GREEN}Autorun enabled.${NC}"
else
    MEOW_AUTORUN="false"
fi

# --------------------------------------------------------
# Mensaje final informativo y de reinicio de terminal
# --------------------------------------------------------
printf "\n${YELLOW} Recuerda: usa 'meow-colorscripts-show' para ver meows específicos y 'meow-colorscripts-names' para consultar nombres disponibles.${NC}\n"
printf "\n${YELLOW} Reinicia tu terminal para que los cambios surtan efecto.${NC}\n"
printf "\n%b\n" "Configuración guardada exitosamente."

# --------------------------------------------------------
# Guardar la configuración en meow.conf
# --------------------------------------------------------
{
    echo "MEOW_THEME=$MEOW_THEME"
    echo "MEOW_SIZE=$MEOW_SIZE"
    echo "MEOW_AUTORUN=$MEOW_AUTORUN"
} > "$MEOW_CONF"
