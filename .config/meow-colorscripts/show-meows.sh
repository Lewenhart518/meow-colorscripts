#!/bin/bash
# ========================================================
# show-meows.sh - Muestra un gato ASCII (meow) de meow-colorscripts
# ========================================================
# Este script lee la configuración almacenada en 
#   $HOME/.config/meow-colorscripts/meow.conf
# y utiliza las variables MEOW_THEME y MEOW_SIZE para determinar
# la carpeta donde se encuentran los archivos de arte.
#
# Si se le pasa un parámetro (e.g., meow-show gato1), intentará mostrar
# el archivo gato1.txt; si no, mostrará un arte aleatorio.
#  
# También lee el idioma desde $HOME/.config/meow-colorscripts/lang.
# Si el idioma es "es" se mostrará en español, de lo contrario en inglés.
# ========================================================

# Ubicación de la configuración
CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"

# Verificar que exista la configuración
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found."
    echo "Please run 'meow-colorscripts-setup' first."
    exit 1
fi
# Cargar la configuración (asegúrate de que meow.conf esté en formato KEY=VALUE)
source "$CONFIG_FILE"

# Verificar que MEOW_THEME y MEOW_SIZE estén definidas
if [ -z "$MEOW_THEME" ] || [ -z "$MEOW_SIZE" ]; then
    echo "MEOW_THEME or MEOW_SIZE is empty."
    echo "Please run 'meow-colorscripts-setup' to configure."
    exit 1
fi

# Determinar el idioma (por defecto inglés)
LANGUAGE="en"
LANG_FILE="$CONFIG_DIR/lang"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Definir la carpeta donde se encuentran los artes ASCII
ART_DIR="$CONFIG_DIR/$MEOW_THEME/$MEOW_SIZE"
if [ ! -d "$ART_DIR" ]; then
    if [ "$LANGUAGE" = "es" ]; then
        echo "No se encontró la carpeta de arte: $ART_DIR"
    else
        echo "Art directory not found: $ART_DIR"
    fi
    exit 1
fi

# Mostrar el arte solicitado o uno aleatorio
if [ -n "$1" ]; then
    # Si se pasa un parámetro, se busca el arte con ese nombre (sin la extensión .txt)
    ART_FILE="$ART_DIR/$1.txt"
    if [ -f "$ART_FILE" ]; then
        cat "$ART_FILE"
    else
        if [ "$LANGUAGE" = "es" ]; then
            echo "No se encontró el arte para '$1'."
        else
            echo "Art for '$1' not found."
        fi
        exit 1
    fi
else
    # Si no se pasa parámetro, se elige un archivo aleatorio del directorio
    FILES=("$ART_DIR"/*.txt)
    if [ ${#FILES[@]} -eq 0 ]; then
        if [ "$LANGUAGE" = "es" ]; then
            echo "No hay arte disponible en: $ART_DIR"
        else
            echo "No art available in: $ART_DIR"
        fi
        exit 1
    fi
    RANDOM_FILE=${FILES[RANDOM % ${#FILES[@]}]}
    cat "$RANDOM_FILE"
fi

