#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
NAMES_FILE="$HOME/.config/meow-colorscripts/names.txt"
MEOW_DIR="$HOME/.config/meow-colorscripts/colorscripts"

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
    MEOW_THEME="normal"
    MEOW_SIZE="normal"
fi

# 🐾 Frases felinas de carga únicas 🐾
LOADING_MSGS=("󰀅 Cargando meows..." " Preparando colores..." " Ajustando detalles..." "★ Refinando arte ANSI..." "󰀅 Explorando el código")
LOADING_USED=()

for i in {1..3}; do 
    while true; do
        LOADING_MSG=${LOADING_MSGS[$RANDOM % ${#LOADING_MSGS[@]}]}
        if [[ ! " ${LOADING_USED[*]} " =~ " $LOADING_MSG " ]]; then
            LOADING_USED+=("$LOADING_MSG")
            break
        fi
    done
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${GREEN}${NC}"
done

# 🐾 Mostrar meows
MEOW_PATH="$MEOW_DIR/$MEOW_THEME/$MEOW_SIZE"
if [[ -d "$MEOW_PATH" ]]; then
    MEOW_FILES=($(ls "$MEOW_PATH" | grep ".txt"))
    MEOW_FILE="${MEOW_FILES[$RANDOM % ${#MEOW_FILES[@]}]}"
    cat "$MEOW_PATH/$MEOW_FILE"
else
    echo -e "${RED}󰀅 Error: No se encontraron meows en $MEOW_PATH.${NC}"
fi

# 🐾 Mostrar comandos activados si existen
if [[ -f "$NAMES_FILE" ]]; then
    echo -e "\n${CYAN}󰀅 Comandos activados:${NC}"
    echo -e "${WHITE}- meows-names${NC}"
    echo -e "${WHITE}- meows-show [name]${NC}"
fi
