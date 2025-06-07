#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"
MEOW_SCRIPT="$HOME/.config/meow-colorscripts/meow-colorscripts/show-meows.sh"

# Colores Nord Aurora
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# Frases felinas de carga 🐾
LOADING_MSGS_ES=(
    "🐾 Ajustando las almohadillas"
    "🐱 Configurando el ronroneo"
    "🐈 Moviendo las patitas"
)
LOADING_MSGS_EN=(
    "🐾 Adjusting the paw pads"
    "🐱 Setting up the purring mode"
    "🐈 Moving the paws"
)

# Crear el directorio si no existe
mkdir -p "$HOME/.config/meow-colorscripts"

# Eliminar configuración previa y crear nuevo archivo
rm -f "$CONFIG_FILE"
echo "MEOW_PATH=normal" > "$CONFIG_FILE"
echo "MEOW_EFFECTS=enabled" >> "$CONFIG_FILE"

# Leer idioma correctamente
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
else
    LANGUAGE="en"
fi

# Animaciones felinas con carga progresiva
for i in {1..3}; do 
    LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
    if [ "$LANGUAGE" == "en" ]; then
        LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
    fi
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${YELLOW}${NC}"
done

echo -e "${GREEN}󰄛 ¡Bienvenido al setup de ansi-meow! 󰄛${NC}"

# Selección de tamaño de gatos
echo -e "\n${CYAN}󰲏 Elige el tamaño de los gatos ANSI:${NC}"
echo -e "${YELLOW}1) Pequeño (en desarrollo)${NC}"
echo -e "${GREEN}2) Normal${NC}"
echo -e "${RED}3) Grande (en desarrollo)${NC}"
read -p "Selecciona una opción [1-3]: " SIZE_OPTION

case $SIZE_OPTION in
    1) MEOW_PATH="small" ;;
    2) MEOW_PATH="normal" ;;
    3) MEOW_PATH="large" ;;
    *) MEOW_PATH="normal" ;;
esac

# Guardar configuración
sed -i "s/^MEOW_PATH=.*/MEOW_PATH=$MEOW_PATH/" "$CONFIG_FILE"

# Activar efectos visuales
echo -e "\n${CYAN}󰠮 ¿Quieres activar efectos visuales (negrita y colores)?${NC}"
echo -e "${GREEN}1) Sí${NC}"
echo -e "${RED}2) No${NC}"
read -p "Selecciona una opción [1-2]: " EFFECTS_OPTION

if [ "$EFFECTS_OPTION" == "1" ]; then
    sed -i "s/^MEOW_EFFECTS=.*/MEOW_EFFECTS=enabled/" "$CONFIG_FILE"
else
    sed -i "s/^MEOW_EFFECTS=.*/MEOW_EFFECTS=disabled/" "$CONFIG_FILE"
fi

# Detectar la shell del usuario
USER_SHELL=$(basename "$SHELL")

# Configuración de inicio automático
echo -e "\n${YELLOW}󱝁 ¿Quieres que ansi-meow se muestre al iniciar la terminal?${NC}"
echo -e "${GREEN}1) Sí${NC}"
echo -e "${RED}2
