#!/bin/bash

INSTALL_DIR="$HOME/.config/meow-colorscripts"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"
LANG_FILE="$INSTALL_DIR/lang"

# 🐾 Asegurar que la carpeta de configuración existe
mkdir -p "$INSTALL_DIR"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Selección de idioma
echo -e "${CYAN} Selecciona tu idioma:${NC}"
echo -e "1) Español"
echo -e "2) English"
read -p "Elige una opción [1/2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi
echo "$LANGUAGE" > "$LANG_FILE"

# 🐾 Frases felinas de carga únicas 🐾
LOADING_USED=()
LOADING_MSGS_ES=("󰀅 Los gatos se estiran" " Acomodando almohadillas" " Afinando maullidos" "★ Ronroneo en progreso" "󰀅 Explorando el código")
LOADING_MSGS_EN=("󰀅 The cats are stretching" " Adjusting paw pads" " Fine-tuning meows" "★ Purring in progress" "󰀅 Exploring the code")

for i in {1..3}; do 
    while true; do
        LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
        if [ "$LANGUAGE" == "en" ]; then
            LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
        fi
        if [[ ! " ${LOADING_USED[*]} " =~ " $LOADING_MSG " ]]; then
            LOADING_USED+=("$LOADING_MSG")
            break
        fi
    done
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${GREEN}${NC}"
done
