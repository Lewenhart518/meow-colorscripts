#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts (Versión Miau)
# ========================================================
# Este script configura meow-colorscripts:
# • Detecta el idioma (usando LANG o el archivo de configuración).
# • Permite seleccionar estilo y tamaño (o tipo para ASCII).
# • Pregunta si activar los comandos:
#       - meow-colorscripts-names (muestra el contenido de names.txt)
#       - meow-colorscripts-show (muestra meows específicos)
#    Se busca primero en ~/.config/meow-colorscripts, de lo contrario
#    usa el archivo de ~/meow-colorscripts.
# • Pregunta si activar autorun para ejecutar "meow-colorscripts" al inicio.
# • Guarda la configuración en meow.conf.
# • Muestra mensajes felinos dinámicos y, al finalizar, recuerda reiniciar la terminal.
# ========================================================

# --- Definición de colores ANSI ---
GREEN='\033[38;2;60;179;113m'       # SeaGreen
RED='\033[38;2;220;20;60m'            # Crimson
YELLOW='\033[38;2;255;215;0m'         # Gold
CYAN='\033[38;2;0;206;209m'           # Dark Turquoise
MAGENTA='\033[38;2;218;112;214m'
BLUE='\033[38;2;65;105;225m'          # Royal Blue
WHITE='\033[38;2;245;245;245m'
NC='\033[0m'                         # Reset

# --- Directorios y archivos ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"
LOCAL_REPO="$HOME/meow-colorscripts"

# Aseguramos la existencia de la carpeta de configuración
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
    # Uso: print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        printf "%b\n" "$1"
    else
        printf "%b\n" "$2"
    fi
}

# Función para mostrar mensajes felinos dinámicos (con ícono)
print_dynamic_message() {
    local message="$1"
    local delay=0.2
    printf "%b" "${MAGENTA}${message}${NC}"
    for i in {1..3}; do
         printf "."
         sleep $delay
    done
    printf " %b\n" "${GREEN}${NC}"
}

# --------------------------------------------------------
# Selección de estilo
# --------------------------------------------------------
if [[ "$LANGUAGE" = "es" ]]; then
    printf "\n${CYAN}▸ Elige tu estilo de meow-colorscripts:${NC}\n"
    printf "  ${YELLOW}1) normal${NC}\n"
    printf "  ${YELLOW}2) nocolor${NC}\n"
    printf "  ${YELLOW}3) themes (nord, catpuccin, everforest)${NC}\n"
    printf "  ${YELLOW}4) ascii${NC}\n"
    printf "  ${YELLOW}5) ascii-color${NC}\n"
    read -p "${BLUE}Selecciona una opción [1-5]: ${NC}" STYLE_OPTION
else
    printf "\n${CYAN}▸ Choose your meow-colorscripts style:${NC}\n"
    printf "  ${YELLOW}1) normal${NC}\n"
    printf "  ${YELLOW}2) nocolor${NC}\n"
    printf "  ${YELLOW}3) themes (nord, catpuccin, everforest)${NC}\n"
    printf "  ${YELLOW}4) ascii${NC}\n"
    printf "  ${YELLOW}5) ascii-color${NC}\n"
    read -p "${BLUE}Select an option [1-5]: ${NC}" STYLE_OPTION
fi
[ -z "$STYLE_OPTION" ] && STYLE_OPTION=1

MEOW_THEME=""
case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3)
        if [[ "$LANGUAGE" = "es" ]]; then
            printf "\n${CYAN}▸ ¿Qué tema deseas usar?${NC}\n"
            printf "  ${YELLOW}1) nord${NC}\n"
            printf "  ${YELLOW}2) catpuccin${NC}\n"
            printf "  ${YELLOW}3) everforest${NC}\n"
            read -p "${BLUE}Selecciona una opción [1-3]: ${NC}" THEME_OPTION
        else
            printf "\n${CYAN}▸ Which theme do you want?${NC}\n"
            printf "  ${YELLOW}1) nord${NC}\n"
            printf "  ${YELLOW}2) catpuccin${NC}\n"
            printf "  ${YELLOW}3) everforest${NC}\n"
            read -p "${BLUE}Select an option [1-3]: ${NC}" THEME_OPTION
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
# Selección de tamaño (o tipo para ASCII)
# --------------------------------------------------------
MEOW_SIZE=""
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
    if [[ "$LANGUAGE" = "es" ]]; then
        printf "\n${CYAN}▸ Selecciona el tipo de ASCII:${NC}\n"
        printf "  ${YELLOW}1) keyboard symbols${NC}\n"
        printf "  ${YELLOW}2) blocks${NC}\n"
        read -p "${BLUE}Selecciona una opción [1-2]: ${NC}" ASCII_OPTION
    else
        printf "\n${CYAN}▸ Select the ASCII type:${NC}\n"
        printf "  ${YELLOW}1) keyboard symbols${NC}\n"
        printf "  ${YELLOW}2) blocks${NC}\n"
        read -p "${BLUE}Select an option [1-2]: ${NC}" ASCII_OPTION
    fi
    if [[ "$ASCII_OPTION" == "1" ]]; then
        MEOW_SIZE="keyboard-symbols"
    elif [[ "$ASCII_OPTION" == "2" ]]; then
        MEOW_SIZE="block"
    else
        MEOW_SIZE="keyboard-symbols"
    fi
else
    if [[ "$LANGUAGE" = "es" ]]; then
        printf "\n${CYAN}▸ Selecciona el tamaño:${NC}\n"
        printf "  ${YELLOW}1) Small${NC}\n"
        printf "  ${YELLOW}2) Normal${NC}\n"
        printf "  ${YELLOW}3) Large${NC}\n"
        read -p "${BLUE}Selecciona una opción [1-3]: ${NC}" SIZE_OPTION
    else
        printf "\n${CYAN}▸ Select the size:${NC}\n"
        printf "  ${YELLOW}1) Small${NC}\n"
        printf "  ${YELLOW}2) Normal${NC}\n"
        printf "  ${YELLOW}3) Large${NC}\n"
        read -p "${BLUE}Select an option [1-3]: ${NC}" SIZE_OPTION
    fi
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi

printf "\n--------------------------------------------------------\n"
print_msg "Has seleccionado: ${GREEN}$MEOW_THEME${NC}, tamaño/tipo: ${GREEN}$MEOW_SIZE${NC}" "You have selected: ${GREEN}$MEOW_THEME${NC}, size/type: ${GREEN}$MEOW_SIZE${NC}"
printf "--------------------------------------------------------\n\n"

# --------------------------------------------------------
# Activación de comandos: 'meow-colorscripts-names' y 'meow-colorscripts-show'
# --------------------------------------------------------
if [[ "$LANGUAGE" = "es" ]]; then
    printf "\n${CYAN}▸ ¿Deseas activar los comandos 'meow-colorscripts-names' y 'meow-colorscripts-show [nombre]'?${NC}\n"
    printf "  ${YELLOW}s) Sí${NC}\n"
    printf "  ${YELLOW}n) No${NC}\n"
    read -p "${BLUE}Selecciona una opción [s/n]: ${NC}" COMANDOS_OPTION
else
    printf "\n${CYAN}▸ Do you want to activate the commands 'meow-colorscripts-names' and 'meow-colorscripts-show [name]'?${NC}\n"
    printf "  ${YELLOW}y) Yes${NC}\n"
    printf "  ${YELLOW}n) No${NC}\n"
    read -p "${BLUE}Select an option [y/n]: ${NC}" COMANDOS_OPTION
fi

if [[ "$COMANDOS_OPTION" =~ ^[sSyY]$ ]]; then
    # Verificar existencia de names.txt
    if [ -f "$CONFIG_DIR/names.txt" ]; then
        print_msg "${GREEN}Archivo 'names.txt' encontrado.${NC}" "${GREEN}'names.txt' found.${NC}"
    else
        print_msg "${RED}No se encontró 'names.txt' en la configuración.${NC}" "${RED}'names.txt' not found in configuration.${NC}"
    fi
    installed_commands=()
    # Instalar comando meow-colorscripts-names (imprime names.txt)
    {
      echo "#!/bin/bash"
      echo "cat $CONFIG_DIR/names.txt"
    } > "$BIN_DIR/meow-colorscripts-names"
    chmod +x "$BIN_DIR/meow-colorscripts-names"
    installed_commands+=( "meow-colorscripts-names" )
    
    # Instalar comando meow-colorscripts-show
    if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
        install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
        installed_commands+=( "meow-colorscripts-show" )
    elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
        install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
        installed_commands+=( "meow-colorscripts-show" )
    else
        print_msg "${RED}No se encontró 'meow-colorscripts-show.sh'.${NC}" "${RED}'meow-colorscripts-show.sh' not found.${NC}"
    fi
    if [ ${#installed_commands[@]} -gt 0 ]; then
        print_msg "${GREEN}Comando(s) ${installed_commands[*]} instalado(s) correctamente.${NC}" "${GREEN}Command(s) ${installed_commands[*]} installed successfully.${NC}"
    fi
fi

# --------------------------------------------------------
# Activar autorun (añadir "meow-colorscripts" en el archivo de la shell)
# --------------------------------------------------------
if [[ "$LANGUAGE" = "es" ]]; then
    printf "\n${CYAN}▸ ¿Deseas activar el autorun de meow-colorscripts al iniciar la terminal?${NC}\n"
    printf "  ${YELLOW}s) Sí${NC}\n"
    printf "  ${YELLOW}n) No${NC}\n"
    read -p "${BLUE}Selecciona una opción [s/n]: ${NC}" AUTORUN_OPTION
else
    printf "\n${CYAN}▸ Do you want to enable autorun for meow-colorscripts on terminal startup?${NC}\n"
    printf "  ${YELLOW}y) Yes${NC}\n"
    printf "  ${YELLOW}n) No${NC}\n"
    read -p "${BLUE}Select an option [y/n]: ${NC}" AUTORUN_OPTION
fi

if [[ "$AUTORUN_OPTION" =~ ^[sSyY]$ ]]; then
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
# Mensaje final
# --------------------------------------------------------
printf "\n${YELLOW} Recuerda: usa 'meow-colorscripts-show' para ver meows específicos y 'meow-colorscripts-names' para consultar nombres.${NC}\n"
printf "\n${YELLOW} Reinicia tu terminal para que los cambios surtan efecto.${NC}\n"
printf "\n${MAGENTA}¡Miau! Configuración guardada exitosamente.${NC}\n"

# --------------------------------------------------------
# Guardar la configuración en meow.conf
# --------------------------------------------------------
{
    echo "MEOW_THEME=$MEOW_THEME"
    echo "MEOW_SIZE=$MEOW_SIZE"
    echo "MEOW_AUTORUN=$MEOW_AUTORUN"
} > "$MEOW_CONF"
