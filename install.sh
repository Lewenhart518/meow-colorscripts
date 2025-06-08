#!/bin/bash

INSTALL_DIR="$HOME/.config"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"
LANG_FILE="$INSTALL_DIR/meow-colorscripts/lang"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Frases felinas de carga únicas 🐾
LOADING_MSGS_ES=("󰏩 Los gatos se estiran" "󰄛 Acomodando almohadillas" "󰌽 Afinando maullidos" " Ronroneo en progreso" "󰗥 Explorando el código")
LOADING_MSGS_EN=("󰏩 The cats are stretching" "󰄛 Adjusting paw pads" "󰌽 Fine-tuning meows" " Purring in progress" "󰗥 Exploring the code")

# 🐾 Selección de idioma
echo -e "${CYAN}  Selecciona tu idioma:${NC}"
echo -e "1) Español"
echo -e "2) English"
read -p "Elige una opción [1-2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi

echo "$LANGUAGE" > "$LANG_FILE"

# 🐾 Animaciones de carga con palomita verde
for i in {1..3}; do 
    LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
    if [ "$LANGUAGE" == "en" ]; then
        LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
    fi
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${GREEN}${NC}"
done

# 🐾 Moviendo configuración correctamente
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
        "fish") 
            echo -e "function ansi-meow" >> "$HOME/.config/fish/config.fish"
            echo -e "    bash ~/.config/meow-colorscripts/show-meows.sh" >> "$HOME/.config/fish/config.fish"
            echo -e "end" >> "$HOME/.config/fish/config.fish"
            ;;
    esac
    echo -e "${GREEN} Alias agregado correctamente.${NC}"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${YELLOW} Debes reiniciar la terminal para que funcione el alias/comando!${NC}"
    else
        echo -e "${YELLOW} You must restart the terminal for the alias/command to work!${NC}"
    fi
else
    echo -e "${RED}󰅟 Error: No se encontró show-meows.sh en ~/.config/meow-colorscripts/.${NC}"
fi

# 🐾 Preguntar si abrir configuración después de instalar
echo -e "\n${CYAN}󰄛 ¿Quieres abrir la configuración ahora?${NC}"
echo -e "1) Sí"
echo -e "2) No"
read -p "Elige una opción [1-2]: " SETUP_OPTION

if [[ "$SETUP_OPTION" == "1" ]]; then
    if [ -f "$SETUP_SCRIPT" ]; then
        echo -e "${CYAN}󰄛 Abriendo configuración...${NC}"
        bash "$SETUP_SCRIPT"
    else
        echo -e "${RED}󰅟 Error: No se encontró setup.sh en ~/meow-colorscripts/.${NC}"
    fi
fi

echo -e "\n${GREEN} Instalación completada exitosamente. ¡Ansi-meow está listo!${NC}"
echo -e "📁 Ubicación de la configuración: ${WHITE}~/.config/meow-colorscripts/${NC}"
