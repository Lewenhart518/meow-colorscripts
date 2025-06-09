#!/bin/bash
# ========================================================
# setup.sh - Configuración de meow-colorscripts
# ========================================================
# Este script configura meow-colorscripts:
# • Detecta el idioma leyendo la variable LANG o el archivo
#   ~/.config/meow-colorscripts/lang (por defecto "en").
# • Solicita al usuario que elija el estilo y el tamaño (o tipo en caso de ascii/ascii-color).
# • Pregunta si se desean activar los comandos de nombres:
#      - Si se activa, se asume que el archivo "names.txt" ya forma parte del repositorio y
#        se encuentra en ~/.config/meow-colorscripts/names.txt.
#      - Instala en ~/.local/bin el comando "meow-colorscripts-names" que muestra el contenido
#        de "names.txt".
#      - Instala en ~/.local/bin el comando "meow-colorscripts-show" usando el archivo "meow-show.sh".
# • Pregunta si se desea activar el autorun para que se ejecute "meow-colorscripts" al iniciar la terminal.
#      - Dependiendo de la shell (Fish, Bash, Zsh, etc.), se añade la línea exacta "meow-colorscripts"
#        sin "&" ni comentarios en el archivo de configuración correspondiente.
# • Guarda la configuración en ~/.config/meow-colorscripts/meow.conf con:
#         MEOW_THEME, MEOW_SIZE y MEOW_AUTORUN.
# • Muestra mensajes de carga felina de forma dinámica.
# ========================================================

# Definición de colores ANSI
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
YELLOW='\033[38;2;235;203;139m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# Directorios y archivos
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LANG_FILE="$CONFIG_DIR/lang"
MEOW_CONF="$CONFIG_DIR/meow.conf"

# Asegurar la existencia de la carpeta de configuración
mkdir -p "$CONFIG_DIR"

# Detección del idioma: usar LANG, si no, leer de LANG_FILE; por defecto "en"
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

# Función para mensajes dinámicos
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
    printf "%b\n" "  3) themes (nord, cat
