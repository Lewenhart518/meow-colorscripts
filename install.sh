#!/bin/bash

INSTALL_DIR="$HOME/.config/meow-colorscripts"
LOCAL_REPO="$HOME/meow-colorscripts"
CONFIG_FILE="$INSTALL_DIR/meow.conf"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'  # Frost
RED='\033[38;2;191;97;106m'     # Aurora Red
YELLOW='\033[38;2;235;203;139m' # Aurora Yellow
CYAN='\033[38;2;143;188;187m'   # Aurora Cyan
WHITE='\033[38;2;216;222;233m'  # Snow Storm
NC='\033[0m'                    # No Color

# Frases felinas para efectos de carga 🐾
LOADING_MSGS_ES=(
    "🐾 Los gatos se están estirando..."
    "🐱 Acomodando las almohadillas..."
    "🐈 Ronroneo en proceso..."
    "🐾 Sacudiendo las patitas..."
    "🐱 Listo para una siesta elegante..."
)
LOADING_MSGS_EN=(
    "🐾 The cats are stretching..."
    "🐱 Adjusting the paw pads..."
    "🐈 Purring in progress..."
    "🐾 Shaking the paws..."
    "🐱 Ready for a stylish catnap..."
)

# Crear la carpeta de configuración antes de escribir cualquier archivo
mkdir -p "$INSTALL_DIR"

# Detectar idioma del usuario
echo -e "${CYAN} Select your language:${NC}"
echo -e "1) English"
echo -e "2) Español"
read -p "Choose an option [1-2]: " LANG_OPTION

if [ "$LANG_OPTION" == "2" ]; then
    LANGUAGE="es"
else
    LANGUAGE="en"
fi

echo "LANGUAGE=$LANGUAGE" > "$INSTALL_DIR/lang"

# Mensaje de instalación con animación felina 🐾
for i in {1..3}; do 
    LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
    if [ "$LANGUAGE" == "en" ]; then
        LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
    fi
    echo -e "${CYAN}$LOADING_MSG...${NC}"
    sleep 1
done

echo -e "${GREEN}󰄛 Preparando la magia felina 󰄛 ...${NC}"
sleep 1

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo -e "${RED}󰅟 Error: 'git' no está instalado. Por favor, instálalo e intenta de nuevo.${NC}"
    exit 1
fi

# Manejo inteligente del repositorio con procesos ocultos
echo -e "${CYAN}󰄛 Clonando ansi-meow...${NC}"
sleep 1
rm -rf "$LOCAL_REPO"
git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO" &> /dev/null

# Mover `.config` desde `~/meow-colorscripts/` a `~/.config/meow-colorscripts`
mkdir -p "$INSTALL_DIR"
mv "$LOCAL_REPO/.config" "$INSTALL_DIR" &> /dev/null

# Crear directorios y copiar archivos solo si existen
mkdir -p "$INSTALL_DIR/small" "$INSTALL_DIR/normal" "$INSTALL_DIR/large"

if [ -d "$LOCAL_REPO/colorscripts" ]; then
    cp -r "$LOCAL_REPO/colorscripts/small/"*.txt "$INSTALL_DIR/small" &> /dev/null
    cp -r "$LOCAL_REPO/colorscripts/normal/"*.txt "$INSTALL_DIR/normal" &> /dev/null
    cp -r "$LOCAL_REPO/colorscripts/large/"*.txt "$INSTALL_DIR/large" &> /dev/null
else
    echo -e "${RED}󰅟 Error: No se encontraron los archivos de colorscripts.${NC}"
    exit 1
fi

# Dar permisos de ejecución a setup.sh
chmod +x "$INSTALL_DIR/setup.sh" &> /dev/null

# Crear archivo de configuración si no existe
echo -e "${CYAN}󰙔 Creando archivo de configuración...${NC}"
sleep 1
if [ ! -f "$CONFIG_FILE" ]; then
    echo "MEOW_PATH=normal" > "$CONFIG_FILE"
    echo "MEOW_EFFECTS=enabled" >> "$CONFIG_FILE"
    echo -e " ${WHITE}Configuración creada en $CONFIG_FILE${NC}"
fi

# Finalizando instalación con animaciones felinas
echo -ne "${CYAN}󱁖 Finalizando la instalación 󱁖 ${NC}"
for i in {1..5}; do echo -ne "."; sleep 0.5; done
echo -e " ${YELLOW}${NC}"

echo -e "${GREEN}󱝁 Instalación completa! Escribe 'ansi-meow' para ver los gatos. 󱝁${NC}"

# Preguntar si ejecutar setup.sh
echo -e "\n${YELLOW}󱝄 ¿Quieres abrir la configuración ahora?${NC}"
echo -e "1) ${GREEN}Sí${NC}"
echo -e "2) ${RED}No${NC}"
read -p "Selecciona una opción [1-2]: " SETUP_OPTION

if [ "$SETUP_OPTION" == "1" ]; then
    echo -e "${CYAN}󰄛 Ejecutando configuración...${NC}"
    bash "$INSTALL_DIR/setup.sh"
fi
