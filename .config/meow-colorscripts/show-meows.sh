#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
COLORSCRIPTS_DIR="$HOME/.config/meow-colorscripts/colorscripts"

# Colores Nord Aurora
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Cargar configuración
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo -e "${RED}󰅟 No se encontró el archivo de configuración, usando valores predeterminados.${NC}"
    MEOW_TYPE="normal"
    MEOW_SIZE="normal"
fi

# 🐾 Validar que `MEOW_TYPE` es una opción válida
VALID_TYPES=("ascii-color" "ascii" "catpuccin" "everforest" "nocolor" "nord" "normal")
if [[ ! " ${VALID_TYPES[@]} " =~ " ${MEOW_TYPE} " ]]; then
    echo -e "${RED}󰅟 Error: Tipo inválido en la configuración (${MEOW_TYPE}). Usando 'normal'.${NC}"
    MEOW_TYPE="normal"
fi

# 🐾 Validar tamaño o tipo según el `MEOW_TYPE`
if [[ "$MEOW_TYPE" == "ascii" || "$MEOW_TYPE" == "ascii-color" ]]; then
    VALID_SIZES=("keyboard-symbols" "block")
else
    VALID_SIZES=("small" "normal" "large")
fi

if [[ ! " ${VALID_SIZES[@]} " =~ " ${MEOW_SIZE} " ]]; then
    echo -e "${RED}󰅟 Error: Tamaño/tipo inválido (${MEOW_SIZE}). Usando 'normal'.${NC}"
    MEOW_SIZE="normal"
fi

# 🐾 Ruta final del colorscript
FINAL_SCRIPT="$COLORSCRIPTS_DIR/$MEOW_TYPE/$MEOW_SIZE.sh"

# 🐾 Verificar si el colorscript existe antes de ejecutarlo
if [ -f "$FINAL_SCRIPT" ]; then
    bash "$FINAL_SCRIPT"
else
    echo -e "${RED}󰅟 Error: No se encontró $MEOW_SIZE.sh en $COLORSCRIPTS_DIR/$MEOW_TYPE/.${NC}"
fi
