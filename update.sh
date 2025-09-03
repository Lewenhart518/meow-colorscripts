#!/bin/bash

GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
NC='\033[0m'

echo -e " ${CYAN}Actualizando meow-colorscripts...${NC}"


cd "$HOME/meow-colorscripts" || { 
    echo -e " ${RED}Error: No se encontró el repositorio local en $HOME/meow-colorscripts.${NC}"; 
    exit 1; 
}


git pull origin main
if [ $? -eq 0 ]; then
    echo -e " ${GREEN}Actualización completada exitosamente.${NC}"
else
    echo -e " ${RED}Error durante la actualización. Revisa tu conexión o configuración.${NC}"
    exit 1
fi


CONFIG_SOURCE="$HOME/meow-colorscripts/.config/meow-colorscripts"
CONFIG_DEST="$HOME/.config/meow-colorscripts"
if [ -d "$CONFIG_SOURCE" ]; then
    cp -r "$CONFIG_SOURCE/"* "$CONFIG_DEST/"
    echo -e " ${GREEN}La configuración se actualizó correctamente.${NC}"
else
    echo -e " ${RED}No se encontró la carpeta de configuración en el repositorio.${NC}"
fi
