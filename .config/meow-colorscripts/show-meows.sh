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
# - Define la carpeta de arte usando MEOW_THEME y MEOW_SIZE.
# - Si se pasa un parámetro, busca el arte cuyo nombre coincida (sin extensión),
#   de lo contrario, selecciona un arte aleatorio.
# ========================================================

CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"
LANG_FILE="$CONFIG_DIR/lang"

# Verificar que exista el archivo de configuración
if [ ! -f "$CONFIG_FILE" ]; then
    echo "No se encontró el archivo de configuración."
    echo "Por favor, ejecuta 'meow-colorscripts-setup' primero."
    exit 1
fi

# Cargar configuración (se espera formato KEY=VALUE)
source "$CONFIG_FILE"

# Verificar que las variables no estén vacías
if [ -z "$MEOW_THEME" ] || [ -z "$MEOW_SIZE" ]; then
    echo "Configuración incompleta. Ejecuta 'meow-colorscripts-setup' para configurarlo."
    exit 1
fi

# Definir el idioma (por defecto "en")
LANGUAGE="en"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para imprimir mensajes según el idioma
print_msg() {
    # print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

# Definir la carpeta de arte según la configuración
ART_DIR="$CONFIG_DIR/$MEOW_THEME/$MEOW_SIZE"
if [ ! -d "$ART_DIR" ]; then
    print_msg "La carpeta de arte \"$ART_DIR\" no existe." "Art folder \"$ART_DIR\" not found."
    exit 1
fi

# Si se pasa un parámetro, se asume que es el nombre del arte (sin extensión)
if [ -n "$1" ]; then
    ART_FILE="$ART_DIR/$1.txt"
    if [ -f "$ART_FILE" ]; then
        cat "$ART_FILE"
    else
        print_msg "No se encontró el arte para \"$1\"." "Art for \"$1\" not found."
        exit 1
    fi
else
    # Seleccionar un archivo aleatorio de la carpeta
    FILES=("$ART_DIR"/*.txt)
    if [ ${#FILES[@]} -eq 0 ]; then
        print_msg "No hay archivos de arte disponibles en \"$ART_DIR\"." "No art files found in \"$ART_DIR\"."
        exit 1
    fi
    RANDOM_FILE=${FILES[RANDOM % ${#FILES[@]}]}
    cat "$RANDOM_FILE"
fi
