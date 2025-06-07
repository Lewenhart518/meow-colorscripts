#!/bin/bash

INSTALL_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$INSTALL_DIR/meow.conf"

# Verificar si ya existe el repositorio
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "\033[38;2;143;188;187m󰠮 Actualizando ansi-meow... \033[0m"
    git -C "$INSTALL_DIR" pull
else
    echo -e "\033[38;2;191;97;106m󰄛 Clonando ansi-meow por primera vez... \033[0m"
    git clone https://github.com/Lewenhart518/meow-colorscripts.git "$INSTALL_DIR"
fi

# Continuar con la ejecución del setup
bash "$INSTALL_DIR/setup.sh"
