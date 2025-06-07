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

# Definir mensajes en cada idioma
if [ "$LANGUAGE" == "es" ]; then
    MSG_INSTALL="${GREEN}󰄛 Preparando la magia felina 󰄛 ...${NC}"
    MSG_COMPLETE="${GREEN}󱝁 Instalación completa! Escribe 'ansi-meow' para ver los gatos, 'meow-colorscripts-setup' para cambiar ajustes, o 'meows-names' para ver la lista de gatos disponibles 󱝁 ${NC}"
    MSG_GIT_ERROR="${RED}󰅟 Error: 'git' no está instalado. Por favor, instálalo e intenta de nuevo.${NC}"
    MSG_CONFIG="${CYAN}󰙔 Creando archivo de configuración...${NC}"
    MSG_SETUP_PROMPT="${YELLOW}󱝄 ¿Quieres abrir la configuración ahora?${NC}"
else
    MSG_INSTALL="${GREEN}󰄛 Preparing the cat magic 󰄛 ...${NC}"
    MSG_COMPLETE="${GREEN}󱝁 Installation complete! Type 'ansi-meow' to see the cats, 'meow-colorscripts-setup' to change settings, or 'meows-names' to view available cat designs 󱝁 ${NC}"
    MSG_GIT_ERROR="${RED}󰅟 Error: 'git' is not installed. Please install it and try again.${NC}"
    MSG_CONFIG="${CYAN}󰙔 Creating configuration file...${NC}"
    MSG_SETUP_PROMPT="${YELLOW}󱝄 Do you want to open setup now?${NC}"
fi

echo -ne "$MSG_INSTALL"
for i in {1..5}; do echo -ne "."; sleep 0.5; done
echo -e " ${YELLOW}${NC}"

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo -e "$MSG_GIT_ERROR"
    exit 1
fi

# Manejo inteligente del repositorio
if [ -d "$LOCAL_REPO/.git" ]; then
    echo -e "${CYAN}󰠮 Actualizando ansi-meow...${NC}"
    git -C "$LOCAL_REPO" pull
else
    echo -e "${CYAN}󰄛 Clonando ansi-meow...${NC}"
    rm -rf "$LOCAL_REPO"
    git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO"
fi

# Mover `.config` desde `~/meow-colorscripts/` a `~/.config/meow-colorscripts`
mkdir -p "$INSTALL_DIR"
mv "$LOCAL_REPO/.config" "$INSTALL_DIR"

# Crear directorios y copiar archivos solo si existen
mkdir -p "$INSTALL_DIR"
