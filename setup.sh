#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script configura meow-colorscripts:
# • Detecta el idioma a usar leyendo la variable LANG o el archivo
#   ~/.config/meow-colorscripts/lang (por defecto "en").
# • Solicita al usuario que elija el estilo y el tamaño (o tipo, en caso de ascii/ascii-color).
# • Pregunta si se desea activar los comandos de nombres:
#       - Si se activa, genera "names.txt" a partir de los archivos .txt en:
#         ~/.config/meow-colorscripts/colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
#       - Instala en ~/.local/bin el comando "meows-names". Si no existe un archivo
#         "show-names.sh", se crea un script básico que simplemente muestra names.txt.
#       - Instala el comando "meow-show" usando el archivo meow-show.sh (el cual debe estar en ~/.config/meow-colorscripts/).
# • Pregunta si se desea activar el autorun (para que se ejecute "meow-colorscripts" automáticamente)
#   y actualiza el archivo de configuración de la shell (Fish, Bash, Zsh u otro) de modo que en el arranque se invoque:
#         meow-colorscripts
# • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf con:
#         MEOW_THEME, MEOW_SIZE y MEOW_AUTORUN.
# • Muestra mensajes de carga felina.
# ========================================================

# --- Definición de colores ANSI ---
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# --- Directorios y archivos ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"

# Asegurarse de que exista la carpeta de configuración
mkdir -p "$CONFIG_DIR"

# --- Detección del idioma ---
if [ -n "$LANG" ]; then
    LANGUAGE="$LANG"
elif [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

# Función para imprimir mensajes según el idioma
print_msg() {
    # Uso: print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        printf "%b\n" "$1"
    else
        printf "%b\n" "$2"
    fi
}

# --- Función para mensajes dinámicos ---
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
# Preguntar si se desea activar los comandos de nombres
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    printf "%b\n" "${CYAN}¿Deseas activar los comandos 'meows-names' y 'meow-show [nombre]'?${NC}"
    printf "%b\n" "  s) Sí"
    printf "%b\n" "  n) No"
    read -p "Selecciona una opción [s/n]: " NAMES_OPTION
else
    printf "%b\n" "${CYAN}Do you want to activate the commands 'meows-names' and 'meow-show [name]'?${NC}"
    printf "%b\n" "  y) Yes"
    printf "%b\n" "  n) No"
    read -p "Select an option [y/n]: " NAMES_OPTION
fi

if [[ "$NAMES_OPTION" =~ ^[sS]|[yY]$ ]]; then
    ART_FOLDER="$CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE"
    mkdir -p "$ART_FOLDER"
    # Generar names.txt a partir de los archivos .txt (sin extensión)
    if ls "$ART_FOLDER"/*.txt &> /dev/null; then
        ls "$ART_FOLDER" | grep "\.txt$" | sed 's/\.txt//' > "$CONFIG_DIR/names.txt"
        print_msg "${GREEN}Archivo de nombres generado correctamente.${NC}" "${GREEN}Names file generated successfully.${NC}"
    else
        print_msg "${YELLOW}Advertencia: No se encontraron archivos .txt en $ART_FOLDER.${NC}" "${YELLOW}Warning: No .txt files found in $ART_FOLDER.${NC}"
    fi
    installed_commands=()
    # Instalar el comando "meows-names"
    if [ -f "$CONFIG_DIR/show-names.sh" ]; then
        install -Dm755 "$CONFIG_DIR/show-names.sh" "$BIN_DIR/meows-names"
        installed_commands+=( "meows-names" )
    else
        # Si no existe, crear un script básico que solo muestra names.txt
        echo "#!/bin/bash" > "$BIN_DIR/meows-names"
        echo "cat $CONFIG_DIR/names.txt" >> "$BIN_DIR/meows-names"
        chmod +x "$BIN_DIR/meows-names"
        installed_commands+=( "meows-names" )
    fi
    # Instalar el comando "meow-show" usando el nuevo archivo meow-show.sh
    if [ -f "$CONFIG_DIR/meow-show.sh" ]; then
        install -Dm755 "$CONFIG_DIR/meow-show.sh" "$BIN_DIR/meow-show"
        installed_commands+=( "meow-show" )
    else
        print_msg "${YELLOW}No se encontró meow-show.sh, se omitirá la instalación de meow-show.${NC}" "${YELLOW}meow-show.sh not found, skipping installation of meow-show.${NC}"
    fi
    if [ ${#installed_commands[@]} -gt 0 ]; then
        print_msg "${GREEN}Comando(s) ${installed_commands[*]} instalado(s) correctamente.${NC}" "${GREEN}Command(s) ${installed_commands[*]} installed successfully.${NC}"
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
# Frases de carga felina (dinámicas)
# --------------------------------------------------------
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
    printf "%b" "$CYAN$RANDOM_MSG"
    for j in {1..3}; do 
         printf "."
         sleep 0.3
    done
    printf " %b\n" "${GREEN}OK${NC}"
done

# --------------------------------------------------------
# Guardar la configuración en meow.conf
# --------------------------------------------------------
{
    echo "MEOW_THEME=$MEOW_THEME"
    echo "MEOW_SIZE=$MEOW_SIZE"
    echo "MEOW_AUTORUN=$MEOW_AUTORUN"
} > "$MEOW_CONF"

print_msg "${GREEN}Configuración guardada exitosamente.${NC}" "${GREEN}Configuration saved successfully.${NC}"
printf "Archivo de configuración: ${WHITE}$MEOW_CONF${NC}\n\n"
