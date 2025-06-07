#!/bin/bash

INSTALL_DIR="$HOME/.config/meow-colorscripts"
LOCAL_REPO="$HOME/meow-colorscripts"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'  # Frost
RED='\033[38;2;191;97;106m'     # Aurora Red
YELLOW='\033[38;2;235;203;139m' # Aurora Yellow
CYAN='\033[38;2;143;188;187m'   # Aurora Cyan
WHITE='\033[38;2;216;222;233m'  # Snow Storm
NC='\033[0m'                    # No Color

# Frases felinas para efectos de carga 🐾
LOADING_MSGS_ES=(
    "🐾 Los gatos se están estirando"
    "🐱 Acomodando las almohadillas"
    "🐈 Ronroneo en proceso"
    "🐾 Sacudiendo las patitas"
    "🐱 Listo para una siesta elegante"
)
LOADING_MSGS_EN=(
    "🐾 The cats are stretching"
    "🐱 Adjusting the paw pads"
    "🐈 Purring in progress"
    "🐾 Shaking the paws"
    "🐱 Ready for a stylish catnap"
)

# Detectar idioma del usuario
echo -e "${CYAN} Select your language:${NC}"
echo -e "1) English"
echo -e "2) Español"
read -p "Choose an option [1-2]: " LANG_OPTION

LANGUAGE="en"
if [ "$LANG_OPTION" == "2" ]; then
    LANGUAGE="es"
fi

echo "$LANGUAGE" > "$INSTALL_DIR/lang"

# Mensajes felinos con efecto de carga progresivo
for i in {1..3}; do 
    LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
    if [ "$LANGUAGE" == "en" ]; then
        LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
    fi
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${YELLOW}${NC}"
done

echo -e "${GREEN}󰄛 Moviendo configuración de meow-colorscripts...${NC}"
sleep 1

# **Verificar que .config existe antes de moverlo**
if [ -d "$LOCAL_REPO/.config" ]; then
    mv "$LOCAL_REPO/.config" "$INSTALL_DIR" &> /dev/null
    echo -e "${GREEN} Configuración movida correctamente.${NC}"
else
    echo -e "${RED}󰅟 Error: No se encontró la carpeta de configuración en ~/meow-colorscripts/.config/.${NC}"
    exit 1
fi

# Preguntar si abrir la configuración ahora
echo -e "\n${CYAN} ¿Quieres abrir la configuración ahora?${NC}"
echo -e "1) ${GREEN}Sí${NC}"
echo -e "2) ${RED}No${NC}"
read -p "Selecciona una opción [1-2]: " SETUP_OPTION

if [ "$SETUP_OPTION" == "1" ]; then
    bash "$INSTALL_DIR/setup.sh"
fi

echo -e "\n${GREEN} Instalación completada exitosamente. ¡Listo para usar ansi-meow!${NC}"
echo -e "📁 Ubicación de la configuración: ${WHITE}~/.config/meow-colorscripts/${NC}"
