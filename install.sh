#!/bin/bash

INSTALL_DIR="$HOME/.config/meow-colorscripts"
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
LOADING_MSGS_ES=("🐾 Los gatos se están estirando" "🐱 Acomodando las almohadillas" "🐈 Ronroneo en proceso")
LOADING_MSGS_EN=("🐾 The cats are stretching" "🐱 Adjusting the paw pads" "🐈 Purring in progress")

# 🐾 Detectar idioma
echo -e "${CYAN} Select your language:${NC}"
echo -e "1) English"
echo -e "2) Español"
read -p "Choose an option [1-2]: " LANG_OPTION

LANGUAGE="en"
if [ "$LANG_OPTION" == "2" ]; then
    LANGUAGE="es"
fi

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

# 🐾 Mover `.config/` a la ubicación correcta
echo -e "${GREEN}󰄛 Moviendo configuración de meow-colorscripts...${NC}"
sleep 1

if [ -d "$LOCAL_REPO/.config" ]; then
    mv "$LOCAL_REPO/.config" "$INSTALL_DIR" &> /dev/null
    echo -e "${GREEN} Configuración movida correctamente.${NC}"
else
    echo -e "${RED}󰅟 Error: No se encontró la carpeta de configuración en ~/meow-colorscripts/.config/.${NC}"
    exit 1
fi

# 🐾 Detectar shell y agregar alias
USER_SHELL=$(basename "$SHELL")
ALIAS_CMD="alias ansi-meow='bash $INSTALL_DIR/ansi-meow.sh'"

echo -e "${CYAN}󰄛 Detectando shell y agregando alias...${NC}"
sleep 1

if [[ "$USER_SHELL" == "bash" ]]; then
    echo "$ALIAS_CMD" >> "$HOME/.bashrc"
    echo -e "${GREEN} Alias agregado en ~/.bashrc.${NC}"
elif [[ "$USER_SHELL" == "zsh" ]]; then
    echo "$ALIAS_CMD" >> "$HOME/.zshrc"
    echo -e "${GREEN} Alias agregado en ~/.zshrc.${NC}"
elif [[ "$USER_SHELL" == "fish" ]]; then
    echo "$ALIAS_CMD" >> "$HOME/.config/fish/config.fish"
    echo -e "${GREEN} Alias agregado en ~/.config/fish/config.fish.${NC}"
else
    echo -e "${RED}󰅟 No se pudo detectar tu shell. Agrega manualmente este alias:${NC}"
    echo -e "${WHITE}$ALIAS_CMD${NC}"
fi

# 🐾 Preguntar si ejecutar configuración
echo -e "\n${CYAN}󱝄 ¿Quieres abrir la configuración ahora?${NC}"
echo -e "1) ${GREEN}Sí${NC}"
echo -e "2) ${RED}No${NC}"
read -p "Selecciona una opción [1-2]: " SETUP_OPTION

if [ "$SETUP_OPTION" == "1" ]; then
    if [ -f "$SETUP_SCRIPT" ]; then
        echo -e "${CYAN}󰄛 Abriendo configuración...${NC}"
        bash "$SETUP_SCRIPT"
    else
        echo -e "${RED}󰅟 Error: No se encontró setup.sh en ~/meow-colorscripts/.${NC}"
    fi
fi

echo -e "${GREEN}󱝁 Instalación completada exitosamente. ¡Listo para usar ansi-meow!${NC}"
