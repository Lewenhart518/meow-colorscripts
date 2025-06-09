#!/bin/bash
# ========================================================
# meow-show.sh - Mostrar arte ASCII de un meow específico
# ========================================================
# Este script muestra el arte ASCII para un meow específico.
# Debe recibir tres argumentos:
#     [estilo] [tamaño] [nombre]
#
# Si se ejecuta sin argumentos, muestra un mensaje de uso.
# Si los parámetros no corresponden a un archivo válido, se
# advierte al usuario y se indica que puede consultar el repositorio
# de GitHub para ver los estilos y tamaños válidos:
# https://github.com/Lewenhart518/meow-colorscripts
#
# Uso:
#     meow-show [estilo] [tamaño] [nombre]
#
# Example usage:
#     meow-show normal normal gato
# ========================================================

# Comprobar que se pasen los tres argumentos
if [[ $# -lt 3 ]]; then
    echo "Uso: meow-show [estilo] [tamaño] [nombre]"
    echo "Usage: meow-show [style] [size] [name]"
    exit 1
fi

STYLE="$1"
SIZE="$2"
NAME="$3"

MEOW_PATH="$HOME/.config/meow-colorscripts/${STYLE}/${SIZE}/${NAME}.txt"

# Si el archivo no existe, mostrar un mensaje de error indicando el repositorio
if [[ ! -f "$MEOW_PATH" ]]; then
    echo "El archivo '$MEOW_PATH' no existe."
    echo "Verifica que el estilo y el tamaño sean válidos o consulta: https://github.com/Lewenhart518/meow-colorscripts"
    echo ""
    echo "The file '$MEOW_PATH' does not exist."
    echo "Please check that the style and size are valid, or refer to: https://github.com/Lewenhart518/meow-colorscripts"
    exit 1
fi

# Si todo es correcto, se muestra el contenido del archivo
cat "$MEOW_PATH"
