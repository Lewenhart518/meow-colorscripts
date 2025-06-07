#!/bin/bash
INSTALL_DIR="$HOME/.config/meow-colorscripts"

echo "  Select your language:"
echo "1) English"
echo "2) Español"
read -p "Choose an option [1-2]: " LANG_OPTION

if [ "$LANG_OPTION" == "2" ]; then
    LANGUAGE="es"
else
    LANGUAGE="en"
fi

echo "LANGUAGE=$LANGUAGE" > "$HOME/.config/meow-colorscripts/lang"

if [ "$LANGUAGE" == "es" ]; then
    MSG_INSTALL="󰄛 Preparando la magia felina 󰄛 ..."
    MSG_SETUP="Bienvenido al setup de ansi-meow"
    MSG_COMPLETE="󱝁 Instalación completa! Escribe 'ansi-meow' para ver los gatos, 'meow-colorscripts-setup' para cambiar ajustes, o 'meows-names' para ver la lista de gatos disponibles 󱝁 "
else
    MSG_INSTALL="󰄛 Preparing the cat magic 󰄛 ..."
    MSG_SETUP="Welcome to ansi-meow setup"
    MSG_COMPLETE="󱝁 Installation complete! Type 'ansi-meow' to see the cats, 'meow-colorscripts-setup' to change settings, or 'meows-names' to view available cat designs 󱝁 "
fi

echo -n "$MSG_INSTALL"
for i in {1..5}; do echo -n "."; sleep 0.5; done
echo "  "

mkdir -p "$INSTALL_DIR/small" "$INSTALL_DIR/normal" "$INSTALL_DIR/large" > /dev/null 2>&1
cp -r colorscripts/small/*.txt "$INSTALL_DIR/small" > /dev/null 2>&1
cp -r colorscripts/normal/*.txt "$INSTALL_DIR/normal" > /dev/null 2>&1
cp -r colorscripts/large/*.txt "$INSTALL_DIR/large" > /dev/null 2>&1

chmod +x "$INSTALL_DIR/meow-show.sh" > /dev/null 2>&1

# Detectar la shell del usuario
USER_SHELL=$(basename "$SHELL")

# Alias de ansi-meow y setup
echo "alias ansi-meow='bash $INSTALL_DIR/meow-show.sh'" >> ~/.${USER_SHELL}rc 2>/dev/null
echo "alias meow-colorscripts-setup='bash $INSTALL_DIR/setup.sh'" >> ~/.${USER_SHELL}rc 2>/dev/null

# Alias de `meows-names`
echo "alias meows-names='ls -1 $INSTALL_DIR/\$(cat $HOME/.config/meow-colorscripts/config | grep MEOW_PATH | cut -d'=' -f2) | sed \"s/\.txt//g\"'" >> ~/.${USER_SHELL}rc 2>/dev/null

# Agregar comando para mostrar un gato por nombre
echo "meows-show() { cat $INSTALL_DIR/\$(cat $HOME/.config/meow-colorscripts/config | grep MEOW_PATH | cut -d'=' -f2)/\$1.txt; }" >> ~/.${USER_SHELL}rc 2>/dev/null

if [ "$LANGUAGE" == "es" ]; then
    MSG_FINALIZING="󱁖 Finalizando la instalación 󱁖 "
else
    MSG_FINALIZING="󱁖 Finalizing installation 󱁖 "
fi

echo -n "$MSG_FINALIZING"

for i in {1..5}; do echo -n "."; sleep 0.5; done
echo "  "

echo -e "\e[1m$MSG_COMPLETE\e[0m"

