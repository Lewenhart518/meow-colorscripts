#!/bin/bash
# ========================================================
# show-meows.sh
# ========================================================
# Este script muestra arte ASCII de meow-colorscripts.
#
# - Carga la configuración desde:
#       ~/.config/meow-colorscripts/meow.conf
# - Carga el idioma desde:
#       ~/.config/meow-colorscripts/lang (por defecto "en")
# - Define la carpeta de arte usando las variables MEOW_THEME y MEOW_SIZE,
#   considerando la carpeta "colorscripts".
#       Ruta: ~/.config/meow-colorscripts/colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
# - Si se pasa un parámetro, busca un archivo cuyo nombre (sin extensión) coincida.
#   Sino, elige un archivo aleatorio.
# ========================================================

CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"
LANG_FILE="$CONFIG_DIR/lang"

# Verificar existencia del archivo de configuración
if [ ! -f "$CONFIG_FILE" ]; then
    echo "No se encontró el archivo de configuración."
    echo "Por favor, ejecuta 'meow-colorscripts-setup' primero."
    exit 1
fi

# Cargar la configuración (formato KEY=VALUE)
source "$CONFIG_FILE"

# Verificar las variables
if [ -z "$MEOW_THEME" ] || [ -z "$MEOW_SIZE" ]; then
    echo "Configuración incompleta. Ejecuta 'meow-colorscripts-setup' para configurarlo."
    exit 1
fi

# Determinar el idioma (por defecto "en")
LANGUAGE="en"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para imprimir mensajes según el idioma
print_msg() {
    # Uso: print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

# Definir la carpeta de arte correctamente (incluyendo "colorscripts")
ART_DIR="$CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE"
if [ ! -d "$ART_DIR" ]; then
    print_msg "La carpeta de arte \"$ART_DIR\" no existe." "Art folder \"$ART_DIR\" not found."
    exit 1
fi

# Seleccionar arte:
# Si se pasa un parámetro, se busca el arte con ese nombre (sin extensión);
# de lo contrario, se selecciona uno aleatorio.
if [ -n "$1" ]; then
    ART_FILE="$ART_DIR/$1.txt"
    if [ -f "$ART_FILE" ]; then
        cat "$ART_FILE"
    else
        print_msg "No se encontró el arte para \"$1\"." "Art for \"$1\" not found."
        exit 1
    fi
else
    FILES=("$ART_DIR"/*.txt)
    if [ ${#FILES[@]} -eq 0 ]; then
        print_msg "No hay archivos de arte disponibles en \"$ART_DIR\"." "No art files found in \"$ART_DIR\"."
        exit 1
    fi
    RANDOM_FILE=${FILES[RANDOM % ${#FILES[@]}]}
    cat "$RANDOM_FILE"
fi
