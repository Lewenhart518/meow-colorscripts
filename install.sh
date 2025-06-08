#!/bin/bash

INSTALL_DIR="$HOME/.config"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# Frases felinas de carga 🐾
LOADING_MSGS_ES=("󰏩 Los gatos se están estirando" "󰄛 Acomodando las almohadillas" " Ronroneo en proceso")
LOADING_MSGS_EN=("󰏩 The cats are stretching" "󰄛 Adjusting the paw pads" " Purring in progress")

# 🐾 Selección de idioma
echo -e "${CYAN} Select your language:${NC}"
echo -e "1) Español"
echo -e "2) English"
read -p "Choose an option [1-2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi

echo "$LANGUAGE" > "$LOCAL_REPO/.config/meow-colorscripts/lang"

# 🐾 Animaciones de carga
for i in {1..3}; do 
    LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
    if [ "$LANGUAGE" == "en" ]; then
        LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
    fi
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${YELLOW}${NC}"
done

# 🐾 Mover configuración a ~/.config/
echo -e "${GREEN}󰄛 Moviendo configuración de meow-colorscripts...${NC}"
sleep 1

mv "$LOCAL_REPO/.config/meow-colorscripts" "$INSTALL_DIR/" &> /dev/null
echo -e "${GREEN} Configuración movida correctamente.${NC}"

# 🐾 Detectar shell y agregar alias
USER_SHELL=$(basename "$SHELL")
ALIAS_CMD="alias ansi-meow='bash ~/.config/meow-colorscripts/show-meows.sh'"

echo -e "${CYAN}󰄛 Detectando shell y agregando alias...${NC}"
sleep 1

if [ -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" ]; then
    case "$USER_SHELL" in
        "bash") echo "$ALIAS_CMD" >> "$HOME/.bashrc" ;;
        "zsh") echo "$ALIAS_CMD" >> "$HOME/.zshrc" ;;
        "fish") echo "$ALIAS_CMD" >> "$HOME/.config/fish/config.fish" ;;
    esac
    echo -e "${GREEN} Alias agregado correctamente.${NC}"
else
    echo -e "${RED}󰅟 Error: No se encontró show-meows.sh en ~/.config/meow-colorscripts/.${NC}"
fi

# 🐾 Preguntar si ejecutar configuración
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${CYAN}  ¿Quieres abrir la configuración ahora?${NC}"
    echo -e "s) sí  n) no"
else
    echo -e "\n${CYAN}  Do you want to open the configuration now?${NC}"
    echo -e "y) yes  n) no"
fi
read -p "Selecciona una opción: " SETUP_OPTION

if [[ "$SETUP_OPTION" =~ ^[sSyY]$ ]]; then
    if [ -f "$SETUP_SCRIPT" ]; then
        echo -e "${CYAN}󰄛 Abriendo configuración...${NC}"
        bash "$SETUP_SCRIPT"
    else
        echo -e "${RED}󰅟 Error: No se encontró setup.sh en ~/meow-colorscripts/.${NC}"
    fi
fi

echo -e "\n${GREEN} Instalación completada exitosamente. ¡Listo para usar ansi-meow!${NC}"
echo -e "📁 Ubicación de la configuración: ${WHITE}~/.config/meow-colorscripts/${NC}"
