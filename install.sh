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
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "s) sí"
    echo -e "n) no"
    read -p "Elige una opción [s/n]: " LANG_OPTION
else
    echo -e "y) yes"
    echo -e "n) no"
    read -p "Choose an option [y/n]: " LANG_OPTION
fi

LANGUAGE="en"
if [[ "$LANG_OPTION" == "s" || "$LANG_OPTION" == "y" ]]; then
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
        if [[ "$LANGUAGE" == "en" ]]; then
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

# 🐾 Moviendo configuración correctamente
echo -e "${GREEN}󰚝 Moviendo configuración de meow-colorscripts...${NC}"
sleep 1

if [[ -d "$LOCAL_REPO/.config/meow-colorscripts" ]]; then
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$INSTALL_DIR/" &> /dev/null
else
    echo -e "${RED}󰀅 Error: No se encontró la carpeta de configuración en $LOCAL_REPO/.config/meow-colorscripts.${NC}"
fi

# 🐾 Verificar que `show-meows.sh` se movió correctamente
if [[ ! -f "$INSTALL_DIR/show-meows.sh" ]]; then
    if [[ -f "$LOCAL_REPO/show-meows.sh" ]]; then
        cp "$LOCAL_REPO/show-meows.sh" "$INSTALL_DIR/"
        echo -e "${GREEN} show-meows.sh movido correctamente.${NC}"
    else
        echo -e "${RED}󰀅 Error: No se encontró show-meows.sh en $LOCAL_REPO. ¿Está en el repositorio correcto?${NC}"
    fi
fi

echo -e "${GREEN} Configuración movida correctamente.${NC}"

# 🐾 Detectar shell y agregar alias
USER_SHELL=$(basename "$SHELL")
ALIAS_CMD="alias ansi-meow='bash ~/.config/meow-colorscripts/show-meows.sh'"

echo -e "${CYAN}󰀅 Detectando shell y agregando alias...${NC}"
sleep 1

if [ -f "$INSTALL_DIR/show-meows.sh" ]; then
    case "$USER_SHELL" in
        "bash") echo "$ALIAS_CMD" >> "$HOME/.bashrc" ;;
        "zsh") echo "$ALIAS_CMD" >> "$HOME/.zshrc" ;;
        "fish") 
            echo -e "function ansi-meow" >> "$HOME/.config/fish/config.fish"
            echo -e "    bash ~/.config/meow-colorscripts/show-meows.sh" >> "$HOME/.config/fish/config.fish"
            echo -e "end" >> "$HOME/.config/fish/config.fish"
            ;;
    esac
    echo -e "${GREEN} Alias agregado correctamente.${NC}"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${YELLOW} Debes reiniciar la terminal para que funcione el alias ${NC}"
    else
        echo -e "${YELLOW} You must restart the terminal for the alias ${NC}"
    fi
else
    echo -e "${RED}󰀅 Error: No se encontró show-meows.sh en ~/.config/meow-colorscripts/.${NC}"
fi

# 🐾 Preguntar si abrir configuración después de instalar
echo -e "\n${CYAN}󰀅 ¿Quieres abrir la configuración ahora?${NC}"
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "s) sí"
    echo -e "n) no"
    read -p "Elige una opción [s/n]: " SETUP_OPTION
else
    echo -e "y) yes"
    echo -e "n) no"
    read -p "Choose an option [y/n]: " SETUP_OPTION
fi

if [[ "$SETUP_OPTION" == "s" || "$SETUP_OPTION" == "y" ]];
