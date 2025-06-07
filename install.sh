#!/bin/bash

INSTALL_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$INSTALL_DIR/meow.conf"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'  # Frost
RED='\033[38;2;191;97;106m'     # Aurora Red
YELLOW='\033[38;2;235;203;139m' # Aurora Yellow
CYAN='\033[38;2;143;188;187m'   # Aurora Cyan
WHITE='\033[38;2;216;222;233m'  # Snow Storm
NC='\033[0m'                    # No Color

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

if [ "$LANGUAGE" == "es" ]; then
    MSG_INSTALL="${GREEN}󰄛 Preparando la magia felina 󰄛 ...${NC}"
    MSG_COMPLETE="${GREEN}󱝁 Instalación completa! Escribe 'ansi-meow' para ver los gatos, 'meow-colorscripts-setup' para cambiar ajustes, o 'meows-names' para ver la lista de gatos disponibles 󱝁 ${NC}"
    MSG_GIT_ERROR="${RED}󰅟 Error: 'git' no está instalado. Por favor, instálalo e intenta de nuevo.${NC}"
    MSG_CONFIG="${CYAN}󰙔 Creando archivo de configuración...${NC}"
else
    MSG_INSTALL="${GREEN}󰄛 Preparing the cat magic 󰄛 ...${NC}"
    MSG_COMPLETE="${GREEN}󱝁 Installation complete! Type 'ansi-meow' to see the cats, 'meow-colorscripts-setup' to change settings, or 'meows-names' to view available cat designs 󱝁 ${NC}"
    MSG_GIT_ERROR="${RED}󰅟 Error: 'git' is not installed. Please install it and try again.${NC}"
    MSG_CONFIG="${CYAN}󰙔 Creating configuration file...${NC}"
fi

echo -n "$MSG_INSTALL"
for i in {1..5}; do echo -n "."; sleep 0.5; done
echo -e " ${YELLOW}${NC}"

# Verificar si git está instalado
if ! command -v git &> /dev/null; then
    echo -e "$MSG_GIT_ERROR"
    exit 1
fi

# Clonar el repositorio
echo -e "${CYAN}󰠮 Cloning repository...${NC}"
git clone https://github.com/Lewenhart518/meow-colorscripts.git "$INSTALL_DIR" || { echo -e "${RED}Error cloning repository.${NC}"; exit 1; }

# Crear directorios y copiar archivos
mkdir -p "$INSTALL_DIR/small" "$INSTALL_DIR/normal" "$INSTALL_DIR/large" > /dev/null 2>&1
cp -r "$INSTALL_DIR/colorscripts/small/"*.txt "$INSTALL_DIR/small" > /dev/null 2>&1
cp -r "$INSTALL_DIR/colorscripts/normal/"*.txt "$INSTALL_DIR/normal" > /dev/null 2>&1
cp -r "$INSTALL_DIR/colorscripts/large/"*.txt "$INSTALL_DIR/large" > /dev/null 2>&1

chmod +x "$INSTALL_DIR/show-meows.sh" "$INSTALL_DIR/setup.sh" > /dev/null 2>&1

# Crear archivo de configuración si no existe
echo -e "$MSG_CONFIG"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "MEOW_PATH=normal" > "$CONFIG_FILE"
    echo "MEOW_EFFECTS=enabled" >> "$CONFIG_FILE"
    echo " ${WHITE}Configuración creada en $CONFIG_FILE${NC}"
fi

# Detectar la shell del usuario
USER_SHELL=$(basename "$SHELL")

# Alias para accesibilidad
echo "alias ansi-meow='bash $INSTALL_DIR/show-meows.sh'" >> ~/.${USER_SHELL}rc 2>/dev/null
echo "alias meow-colorscripts-setup='bash $INSTALL_DIR/setup.sh'" >> ~/.${USER_SHELL}rc 2>/dev/null
echo "alias meows-names='ls -1 $INSTALL_DIR/\$(cat $CONFIG_FILE | grep MEOW_PATH | cut -d'=' -f2) | sed \"s/\.txt//g\"'" >> ~/.${USER_SHELL}rc 2>/dev/null
echo "meows-show() { cat $INSTALL_DIR/\$(cat $CONFIG_FILE | grep MEOW_PATH | cut -d'=' -f2)/\$1.txt; }" >> ~/.${USER_SHELL}rc 2>/dev/null

# Finalizando instalación
if [ "$LANGUAGE" == "es" ]; then
    MSG_FINALIZING="${CYAN}󱁖 Finalizando la instalación 󱁖 ${NC}"
else
    MSG_FINALIZING="${CYAN}󱁖 Finalizing installation 󱁖 ${NC}"
fi

echo -n "$MSG_FINALIZING"
for i in {1..5}; do echo -n "."; sleep 0.5; done
echo -e " ${YELLOW}${NC}"

echo -e "$MSG_COMPLETE"

