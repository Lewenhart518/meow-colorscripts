#!/bin/bash
# ========================================================
# show-meows.sh
# ========================================================
# Este script muestra el arte ANSI de un gato (meow) seleccionado,
# basándose en la configuración guardada en ~/.config/meow-colorscripts/meow.conf.
# Se espera que los archivos de arte se encuentren en:
#   $HOME/.config/meow-colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
# Si no se encuentra ningún archivo .txt en dicho directorio,
# se mostrará un mensaje de error personalizado ubicado en:
#   $HOME/.config/meow-colorscripts/colorscripts/error.txt
#
# Uso:
#   meow-show [nombre]
# ========================================================

# Colores para mensajes
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
NC='\033[0m'

# Cargar la configuración
CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo -e " ${RED}Error: Archivo de configuración no encontrado. Ejecuta 'meow-colorscripts-setup' primero.${NC}"
    exit 1
fi

# Valores por defecto, en caso de que no estén definidos
: ${MEOW_THEME:="normal"}
: ${MEOW_SIZE:="normal"}

# Definir la ruta del directorio de arte ANSI
ART_DIR="$HOME/.config/meow-colorscripts/$MEOW_THEME/$MEOW_SIZE"

# Si el directorio de arte no existe, muestra un error y se sale.
if [ ! -d "$ART_DIR" ]; then
    echo -e " ${RED}Error: No se encontró el directorio de arte ($ART_DIR).${NC}"
    exit 1
fi

# Verificar si existen archivos .txt en $ART_DIR
TXT_COUNT=$(find "$ART_DIR" -maxdepth 1 -type f -name "*.txt" | wc -l)
if [ "$TXT_COUNT" -eq 0 ]; then
    ERROR_FILE="$HOME/.config/meow-colorscripts/colorscripts/error.txt"
    if [ -f "$ERROR_FILE" ]; then
        cat "$ERROR_FILE"
    else
        echo -e " ${RED}Error: No se encontraron archivos .txt y tampoco se pudo localizar $ERROR_FILE.${NC}"
    fi
    exit 1
fi

# Validar la entrada: se espera al menos un parámetro con el nombre del gato
if [ "$#" -eq 0 ]; then
    echo -e " ${CYAN}No se proporcionó el nombre de un gato.${NC}"
    echo -e " ${CYAN}Utiliza 'meows-names' para ver los nombres disponibles.${NC}"
    exit 1
fi

# Obtener el nombre del gato y construir la ruta al archivo
CAT_NAME="$1"
FILE="$ART_DIR/$CAT_NAME.txt"

if [ -f "$FILE" ]; then
    cat "$FILE"
else
    echo -e " ${RED}Error: No se encontró el arte para el gato '$CAT_NAME' en $ART_DIR.${NC}"
    exit 1
fi
