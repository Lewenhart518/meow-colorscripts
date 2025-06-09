#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts (Versión Miau)
# ========================================================
# Este script configura meow-colorscripts:
# • Carga el idioma (usando LANG o ~/.config/meow-colorscripts/lang; "en" por defecto)
# • Permite seleccionar el estilo y el tamaño o tipo (para ASCII)
# • Si se selecciona "themes", pregunta por el tema (nord, catpuccin, everforest)
# • Muestra un resumen de la configuración seleccionada
# • Pregunta si activar los comandos:
#       - meow-colorscripts-names (que muestra el contenido de names.txt)
#       - meow-colorscripts-show (para mostrar arte ASCII específico)
# • Pregunta si activar autorun (añadiendo "meow-colorscripts" en el archivo de configuración de la shell)
# • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf
# ========================================================

# --- Definición de colores ANSI para los mensajes de setup ---
GREEN='\033[38;2;60;179;113m'       # SeaGreen
RED='\033[38;2;220;20;60m'           # Crimson
YELLOW='\033[38;2;255;215;0m'         # Gold
CYAN='\033[38;2;0;206;209m'           # DarkTurquoise
MAGENTA='\033[38;2;218;112;214m'
BLUE='\033[38;2;65;105;225m'          # RoyalBlue
WHITE='\033[38;2;245;245;245m'
NC='\033[0m'                        # Reset

# --- Directorios y rutas ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"    # (usado en install, no en setup)
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"
LOCAL_REPO="$HOME/meow-colorscripts"  # (usado en install)

# Aseguramos que exista la carpeta de configuración
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
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

# Función para mostrar mensajes dinámicos
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

# ---------------------------------------
# 1. Seleccionar el estilo
# ---------------------------------------
if [[ "$LANGUAGE" = "es" ]]; then
    echo -e "\n${CYAN}▸ Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "  ${YELLOW}1) normal${NC}"
    echo -e "  ${YELLOW}2) nocolor${NC}"
    echo -e "  ${YELLOW}3) themes (nord, catpuccin, everforest)${NC}"
    echo -e "  ${YELLOW}4) ascii${NC}"
    echo -e "  ${YELLOW}5) ascii-color${NC}"
    read -p "${BLUE}▸ Selecciona una opción [1-5]: ${NC}" STYLE_OPTION
else
    echo -e "\n${CYAN}▸ Choose your meow-colorscripts style:${NC}"
    echo -e "  ${YELLOW}1) normal${NC}"
    echo -e "  ${YELLOW}2) nocolor${NC}"
    echo -e "  ${YELLOW}3) themes (nord, catpuccin, everforest)${NC}"
    echo -e "  ${YELLOW}4) ascii${NC}"
    echo -e "  ${YELLOW}5) ascii-color${NC}"
    read -p "${BLUE}▸ Select an option [1-5]: ${NC}" STYLE_OPTION
fi
# Si se deja vacío, se asume 1 (normal)
if [ -z "$STYLE_OPTION" ]; then
    STYLE_OPTION=1
fi

MEOW_THEME=""
case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3)
        if [[ "$LANGUAGE" = "es" ]]; then
            echo -e "\n${CYAN}▸ ¿Qué tema deseas usar?${NC}"
            echo -e "  ${YELLOW}1) nord${NC}"
            echo -e "  ${YELLOW}2) catpuccin${NC}"
            echo -e "  ${YELLOW}3) everforest${NC}"
            read -p "${BLUE}▸ Selecciona una opción [1-3]: ${NC}" THEME_OPTION
        else
            echo -e "\n${CYAN}▸ Which theme do you want to use?${NC}"
            echo -e "  ${YELLOW}1) nord${NC}"
            echo -e "  ${YELLOW}2) catpuccin${NC}"
            echo -e "  ${YELLOW}3) everforest${NC}"
            read -p "${BLUE}▸ Select an option [1-3]: ${NC}" THEME_OPTION
        fi
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="nord" ;;  # por defecto
        esac
        ;;
    4) MEOW_THEME="ascii" ;;
    5) MEOW_THEME="ascii-color" ;;
    *) MEOW_THEME="normal" ;;
esac

# ---------------------------------------
# 2. Seleccionar el tamaño o el tipo (para ascii/ascii-color)
# ---------------------------------------
MEOW_SIZE=""
if [[ "$STYLE_OPTION" -eq 4 || "$STYLE_OPTION" -eq 5 ]]; then
    # Si el estilo es ascii o ascii-color, preguntar por el tipo ASCII
    if [[ "$LANGUAGE" = "es" ]]; then
        echo -e "\n${CYAN}▸ Selecciona el tipo de ASCII:${NC}"
        echo -e "  ${YELLOW}1) keyboard symbols${NC}"
        echo -e "  ${YELLOW}2) blocks${NC}"
        read -p "${BLUE}▸ Selecciona una opción [1-2]: ${NC}" ASCII_OPTION
    else
        echo -e "\n${CYAN}▸ Select the ASCII type:${NC}"
        echo -e "  ${YELLOW}1) keyboard symbols${NC}"
        echo -e "  ${YELLOW}2) blocks${NC}"
        read -p "${BLUE}▸ Select an option [1-2]: ${NC}" ASCII_OPTION
    fi
    if [[ "$ASCII_OPTION" == "1" ]]; then
        MEOW_SIZE="keyboard-symbols"
    elif [[ "$ASCII_OPTION" == "2" ]]; then
        MEOW_SIZE="blocks"
    else
        MEOW_SIZE="keyboard-symbols"
    fi
else
    # Para estilos distintos a ascii, elegir el tamaño
    if [[ "$LANGUAGE" = "es" ]]; then
        echo -e "\n${CYAN}▸ Selecciona el tamaño:${NC}"
        echo -e "  ${YELLOW}1) Small${NC}"
        echo -e "  ${YELLOW}2) Normal${NC}"
        echo -e "  ${YELLOW}3) Large${NC}"
        read -p "${BLUE}▸ Selecciona una opción [1-3]: ${NC}" SIZE_OPTION
    else
        echo -e "\n${CYAN}▸ Select the size:${NC}"
        echo -e "  ${YELLOW}1) Small${NC}"
        echo -e "  ${YELLOW}2) Normal${NC}"
        echo -e "  ${YELLOW}3) Large${NC}"
        read -p "${BLUE}▸ Select an option [1-3]: ${NC}" SIZE_OPTION
    fi
    case "$SIZE_OPTION" in
        1) MEOW_SIZE="small" ;;
        2) MEOW_SIZE="normal" ;;
        3) MEOW_SIZE="large" ;;
        *) MEOW_SIZE="normal" ;;
    esac
fi

# ---------------------------------------
# Resumen de la configuración
# ---------------------------------------
echo -e "\n--------------------------------------------------------"
print_msg "Has seleccionado: ${GREEN}${MEOW_THEME}${NC}, tamaño/tipo: ${GREEN}${MEOW_SIZE}${NC}" \
          "You have selected: ${GREEN}${MEOW_THEME}${NC}, size/type: ${GREEN}${MEOW_SIZE}${NC}"
echo -e "--------------------------------------------------------\n"

# ---------------------------------------
# 3. Preguntar si se desean activar comandos adicionales:
#    - meow-colorscripts-names (muestra names.txt)
#    - meow-colorscripts-show (para mostrar arte específico)
# ---------------------------------------
if [[ "$LANGUAGE" = "es" ]]; then
    echo -e "${CYAN}▸ ¿Deseas activar los comandos 'meow-colorscripts-names' y 'meow-colorscripts-show [nombre]'?${NC}"
    echo -e "  ${YELLOW}s) Sí${NC}"
    echo -e "  ${YELLOW}n) No${NC}"
    read -p "${BLUE}▸ Selecciona una opción [s/n]: ${NC}" COMANDOS_OPTION
else
    echo -e "${CYAN}▸ Do you want to activate the commands 'meow-colorscripts-names' and 'meow-colorscripts-show [name]'?${NC}"
    echo -e "  ${YELLOW}y) Yes${NC}"
    echo -e "  ${YELLOW}n) No${NC}"
    read -p "${BLUE}▸ Select an option [y/n]: ${NC}" COMANDOS_OPTION
fi

if [[ "$COMANDOS_OPTION" =~ ^[sSyY]$ ]]; then
    # Verificar existencia de names.txt
    if [ -f "$CONFIG_DIR/names.txt" ]; then
        print_msg "${GREEN}Archivo 'names.txt' encontrado.${NC}" "${GREEN}'names.txt' found.${NC}"
    else
        print_msg "${RED}No se encontró 'names.txt' en la configuración.${NC}" "${RED}'names.txt' not found in configuration.${NC}"
    fi
    installed_commands=()
    # Instalar comando "meow-colorscripts-names" (imprime names.txt)
    {
      echo "#!/bin/bash"
      echo "cat $CONFIG_DIR/names.txt"
    } > "$BIN_DIR/meow-colorscripts-names"
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
        print_msg "${RED}No se encontró 'meow-colorscripts-show.sh'.${NC}" "${RED}'meow-colorscripts-show.sh' not found.${NC}"
    fi
    if [ ${#installed_commands[@]} -gt 0 ]; then
        print_msg "${GREEN}Comando(s) ${installed_commands[*]} instalado(s) correctamente.${NC}" \
                  "${GREEN}Command(s) ${installed_commands[*]} installed successfully.${NC}"
    fi
fi

# ---------------------------------------
# 4. Preguntar por autorun y actualizar el archivo de configuración de la shell
# ---------------------------------------
if [[ "$LANGUAGE" = "es" ]]; then
    echo -e "\n${CYAN}▸ ¿Deseas activar el autorun de meow-colorscripts al iniciar la terminal?${NC}"
    echo -e "  ${YELLOW}s) Sí${NC}"
    echo -e "  ${YELLOW}n) No${NC}"
    read -p "${BLUE}▸ Selecciona una opción [s/n]: ${NC}" AUTORUN_OPTION
else
    echo -e "\n${CYAN}▸ Do you want to enable autorun for meow-colorscripts on terminal startup?${NC}"
    echo -e "  ${YELLOW}y) Yes${NC}"
    echo -e "  ${YELLOW}n) No${NC}"
    read -p "${BLUE}▸ Select an option [y/n]: ${NC}" AUTORUN_OPTION
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

# ---------------------------------------
# 5. Mensaje final y guardar la configuración
# ---------------------------------------
echo -e "\n${YELLOW} Recuerda: usa 'meow-colorscripts-show' para ver arte específico y 'meow-colorscripts-names' para consultar nombres.${NC}"
echo -e "${YELLOW} Reinicia tu terminal para que los cambios surtan efecto.${NC}\n"
echo -e "${MAGENTA}¡Miau! Configuración guardada exitosamente.${NC}\n"

# Guardar la configuración en meow.conf
{
    echo "MEOW_THEME=$MEOW_THEME"
    echo "MEOW_SIZE=$MEOW_SIZE"
    echo "MEOW_AUTORUN=$MEOW_AUTORUN"
} > "$MEOW_CONF"
