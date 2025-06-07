#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
SCRIPTS_DIR="$HOME/.config/meow-colorscripts/colorscripts"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Cargar configuración
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo -e "${RED}󰅟 Error: No se encontró el archivo de configuración en $CONFIG_FILE.${NC}"
    exit 1
fi

# 🐾 Construcción de ruta correcta
SCRIPT_PATH="$SCRIPTS_DIR/$MEOW_THEME/$MEOW_SIZE"

if [[ ! -d "$SCRIPT_PATH" ]]; then
    echo -e "${RED}󰅟 Error: No se encontró la carpeta $SCRIPT_PATH.${NC}"
    echo -e "${WHITE}Verifica la estructura y asegúrate de que los archivos existen.${NC}"
    exit 1
fi

# 🐾 Mostrar los archivos `.txt` de la carpeta seleccionada
echo -e "\n${CYAN}╭╴󰣇 ⋆.˚✮ Leonardo ✮˚.⋆ ~/meow-colorscripts 󰫢 ${NC}"
echo -e "╰─|ansi-meow"
cat "$SCRIPT_PATH"/*.txt

# 🐾 Generar lista de nombres de gatos
NAMES_FILE="$HOME/.config/meow-colorscripts/names.txt"
ls "$SCRIPT_PATH" | grep ".txt" | sed 's/.txt//' > "$NAMES_FILE"
echo -e "${GREEN} Archivo de nombres generado correctamente: ${WHITE}$NAMES_FILE${NC}"
