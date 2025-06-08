#!/bin/bash
# ========================================================
# update.sh - Actualización de meow-colorscripts
# ========================================================
# Este script actualiza el repositorio local de meow-colorscripts
# y, si existen actualizaciones en la carpeta de configuración,
# las copia a ~/.config/meow-colorscripts.
#
# Para que funcione correctamente, asegúrate de tener configurado
# correctamente el repositorio (mediante git) y una conexión activa.
# ========================================================

# Variables de color para mensajes
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
CYAN='\033[38;2;143;188;187m'
NC='\033[0m'

echo -e " ${CYAN}Actualizando meow-colorscripts...${NC}"

# Cambiar al directorio del repositorio local
cd "$HOME/meow-colorscripts" || { 
    echo -e " ${RED}Error: No se encontró el repositorio local en $HOME/meow-colorscripts.${NC}"; 
    exit 1; 
}

# Actualizar el repositorio con git pull
git pull origin main
if [ $? -eq 0 ]; then
    echo -e " ${GREEN}Actualización completada exitosamente.${NC}"
else
    echo -e " ${RED}Error durante la actualización. Revisa tu conexión o configuración.${NC}"
    exit 1
fi

# Opcional: Actualizar la carpeta de configuración, si se han realizado cambios
CONFIG_SOURCE="$HOME/meow-colorscripts/.config/meow-colorscripts"
CONFIG_DEST="$HOME/.config/meow-colorscripts"
if [ -d "$CONFIG_SOURCE" ]; then
    cp -r "$CONFIG_SOURCE/"* "$CONFIG_DEST/"
    echo -e " ${GREEN}La configuración se actualizó correctamente.${NC}"
else
    echo -e " ${RED}No se encontró la carpeta de configuración en el repositorio.${NC}"
fi
