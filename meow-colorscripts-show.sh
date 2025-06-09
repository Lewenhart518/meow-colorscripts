#!/bin/bash
# ========================================================
# meow-colorscripts-show.sh
# ========================================================
# Este script muestra arte ASCII específico de meow-colorscripts.
#
# Uso:
#   meow-colorscripts-show [style] [size or type in case you choose ascii] [name]
#
# Comportamiento:
# • Si no se pasan argumentos, muestra un mensaje de uso (traducido según el idioma).
# • Si se pasan argumentos, forma la ruta:
#       ~/.config/meow-colorscripts/colorscripts/<style>/<size>/<name>.txt
#   y muestra su contenido con echo -e.
# • Si el archivo no existe, muestra un mensaje de error (traducido) y sugiere usar
#   'meow-colorscripts-names' o consultar:
#   https://github.com/Lewenhart518/meow-colorscripts
# ========================================================

CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"
LANG_FILE="$CONFIG_DIR/lang"

# Comprobar configuración
if [ ! -f "$CONFIG_FILE" ]; then
  echo "No se encontró el archivo de configuración."
  echo "Por favor, ejecuta 'meow-colorscripts-setup' primero."
  exit 1
fi
source "$CONFIG_FILE"

# Cargar idioma, por defecto "en"
LANGUAGE="en"
if [ -f "$LANG_FILE" ]; then
  LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para imprimir mensajes según el idioma
print_msg() {
  # Argumentos: $1 = mensaje en español, $2 = mensaje en inglés
  if [ "$LANGUAGE" = "es" ]; then
    echo -e "$1"
  else
    echo -e "$2"
  fi
}

# Si no se pasan exactamente 3 argumentos, mostrar mensaje de uso.
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

# Asignación de argumentos
STYLE="$1"
SIZE="$2"
NAME="$3"

# Formar la ruta al archivo de arte
ART_FILE="$CONFIG_DIR/colorscripts/$STYLE/$SIZE/$NAME.txt"

# Comprobar que el archivo existe, y en caso afirmativo mostrarlo
if [ -f "$ART_FILE" ]; then
  echo -e "$(cat "$ART_FILE")"
else
  print_msg "El archivo '$ART_FILE' no existe. Verifica que el estilo, el tamaño y el nombre sean válidos o consulta: https://github.com/Lewenhart518/meow-colorscripts" \
            "The file '$ART_FILE' does not exist. Please check that the style, size and name are valid, or refer to: https://github.com/Lewenhart518/meow-colorscripts"
  exit 1
fi
