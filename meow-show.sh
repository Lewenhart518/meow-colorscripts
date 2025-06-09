#!/bin/bash
# ========================================================
# meow-show.sh - Mostrar arte ASCII de un meow específico
# ========================================================
# Descripción:
#   Este script muestra el arte ASCII para un meow específico.
#   Debe recibir tres argumentos:
#       [estilo] [tamaño] [nombre]
#
# Uso:
#   meow-show [estilo] [tamaño] [nombre]
#
# Example usage:
#   meow-show normal normal gato
#
# Si el archivo correspondiente no existe, se mostrará un mensaje informándolo.
# ========================================================

# Ensure that three arguments are provided (Asegurarse que se pasen los tres argumentos)
if [[ $# -lt 3 ]]; then
    echo "Uso: meow-show [estilo] [tamaño] [nombre]"
    echo "Usage: meow-show [style] [size] [name]"
    exit 1
fi

STYLE="$1"
SIZE="$2"
NAME="$3"

MEOW_PATH="$HOME/.config/meow-colorscripts/${STYLE}/${SIZE}/${NAME}.txt"

# Check if the file exists and display its content (Verificar si el archivo existe y mostrar su contenido)
if [[ -f "$MEOW_PATH" ]]; then
    cat "$MEOW_PATH"
else
    echo "El archivo '$MEOW_PATH' no existe. Verifica que el nombre sea correcto."
    echo "The file '$MEOW_PATH' does not exist. Please check that the name is correct."
fi
