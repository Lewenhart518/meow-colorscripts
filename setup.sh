#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"

# Leer idioma
if [ -f "$LANG_FILE" ]; then
    source "$LANG_FILE"
else
    LANGUAGE="en"
fi

if [ "$LANGUAGE" == "es" ]; then
    MSG_SETUP="󰄛 ¡Bienvenido al setup de ansi-meow! 󰄛"
    MSG_SIZE="󰲏 Elige el tamaño de los gatos ANSI:"
    MSG_OPTION1="1) Pequeño"
    MSG_OPTION2="2) Normal"
    MSG_OPTION3="3) Grande"
    MSG_EFFECTS="󰠮 ¿Quieres activar efectos visuales (negrita y colores)?"
    MSG_STARTUP="󱝁 ¿Quieres que ansi-meow se muestre al iniciar la terminal?"
    MSG_YES="1) Sí"
    MSG_NO="2) No"
    MSG_DONE=" Configuración completa! Escribe 'ansi-meow' para ver los gatos."
else
    MSG_SETUP="󰄛 Welcome to ansi-meow setup! 󰄛"
    MSG_SIZE="󰲏 Choose the size of ANSI cats:"
    MSG_OPTION1="1) Small"
    MSG_OPTION2="2) Normal"
    MSG_OPTION3="3) Large"
    MSG_EFFECTS="󰠮 Do you want to enable visual effects (bold and colors)?"
    MSG_STARTUP="󱝁 Do you want ansi-meow to run automatically when opening the terminal?"
    MSG_YES="1) Yes"
    MSG_NO="2) No"
    MSG_DONE=" Setup complete! Type 'ansi-meow' to see your customized cats."
fi

echo "$MSG_SETUP"

# Selección de tamaño de gatos
echo -e "\n$MSG_SIZE"
echo "$MSG_OPTION1"
echo "$MSG_OPTION2"
echo "$MSG_OPTION3"
read -p "Select an option [1-3]: " SIZE_OPTION

case $SIZE_OPTION in
    1) MEOW_PATH="small" ;;
    2) MEOW_PATH="normal" ;;
    3) MEOW_PATH="large" ;;
    *) MEOW_PATH="normal" ;;
esac

# Guardar configuración en meow.conf
echo "MEOW_PATH=$MEOW_PATH" > "$CONFIG_FILE"

# Activar efectos visuales
echo -e "\n$MSG_EFFECTS"
echo "$MSG_YES"
echo "$MSG_NO"
read -p "Select an option [1-2]: " EFFECTS_OPTION

if [ "$EFFECTS_OPTION" == "1" ]; then
    echo "MEOW_EFFECTS=enabled" >> "$CONFIG_FILE"
else
    echo "MEOW_EFFECTS=disabled" >> "$CONFIG_FILE"
fi

# Detectar la shell del usuario
USER_SHELL=$(basename "$SHELL")

# Configuración de inicio automático
echo -e "\n$MSG_STARTUP"
echo "$MSG_YES"
echo "$MSG_NO"
read -p "Select an option [1-2]: " STARTUP_OPTION

if [ "$STARTUP_OPTION" == "1" ]; then
    case "$USER_SHELL" in
        "bash") echo "ansi-meow" >> ~/.bashrc ;;
        "zsh") echo "ansi-meow" >> ~/.zshrc ;;
        "fish") echo "ansi-meow" >> ~/.config/fish/config.fish ;;
    esac
fi

echo -e "\n\e[1m$MSG_DONE\e[0m"

