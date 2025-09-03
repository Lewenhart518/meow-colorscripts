#!/bin/bash

CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"
LANG_FILE="$CONFIG_DIR/lang"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "No se encontró el archivo de configuración."
  echo "Por favor, ejecuta 'meow-colorscripts-setup' primero."
  exit 1
fi
source "$CONFIG_FILE"

LANGUAGE="en"
if [ -f "$LANG_FILE" ]; then
  LANGUAGE=$(cat "$LANG_FILE")
fi

print_msg() {

  if [ "$LANGUAGE" = "es" ]; then
    echo -e "$1"
  else
    echo -e "$2"
  fi
}


if [ "$#" -ne 3 ]; then
  if [ "$LANGUAGE" = "es" ]; then
    echo -e "Uso del comando 'meow-colorscripts-show':\n"
    echo -e "  meow-colorscripts-show [estilo] [tamaño o tipo, si elegiste ascii] [nombre]\n"
    echo -e "Para consultar los nombres disponibles, usa 'meow-colorscripts-names' o visita:"
    echo -e "  https://github.com/Lewenhart518/meow-colorscripts"
  else
    echo -e "Usage of 'meow-colorscripts-show' command:\n"
    echo -e "  meow-colorscripts-show [style] [size or type (for ascii)] [name]\n"
    echo -e "To see the available names, use 'meow-colorscripts-names' or visit:"
    echo -e "  https://github.com/Lewenhart518/meow-colorscripts"
  fi
  exit 1
fi


STYLE="$1"
SIZE="$2"
NAME="$3"


ART_FILE="$CONFIG_DIR/colorscripts/$STYLE/$SIZE/$NAME.txt"


if [ -f "$ART_FILE" ]; then
  echo -e "$(cat "$ART_FILE")"
else
  print_msg "El archivo '$ART_FILE' no existe. Verifica que el estilo, el tamaño y el nombre sean válidos o consulta: https://github.com/Lewenhart518/meow-colorscripts" \
            "The file '$ART_FILE' does not exist. Please check that the style, size and name are valid, or refer to: https://github.com/Lewenhart518/meow-colorscripts"
  exit 1
fi
