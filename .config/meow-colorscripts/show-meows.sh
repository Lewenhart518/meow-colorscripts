#!/bin/bash
# ========================================================
# show-meows.sh
# ========================================================
# Este script muestra arte ASCII de meow-colorscripts.
#
# • Carga la configuración desde ~/.config/meow-colorscripts/meow.conf
# • Carga el idioma desde ~/.config/meow-colorscripts/lang (por defecto "en")
# • La carpeta de arte se define como:
#       ~/.config/meow-colorscripts/colorscripts/<MEOW_THEME>/<MEOW_SIZE>/
# • Si se pasa un parámetro, busca el archivo <parámetro>.txt; de lo contrario,
#   selecciona uno aleatorio.
# • Si no se detectan archivos .txt en la carpeta de arte, se muestra el contenido
#   de ~/.config/meow-colorscripts/colorscripts/error.txt (este archivo debe existir y contener arte ANSI de error).
# • Se usa echo -e para que se interpreten los códigos ANSI.
# ========================================================

CONFIG_DIR="$HOME/.config/meow-colorscripts"
CONFIG_FILE="$CONFIG_DIR/meow.conf"
LANG_FILE="$CONFIG_DIR/lang"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "No se encontró el archivo de configuración."
    echo "Por favor, ejecuta 'meow-colorscripts-setup' primero."
    exit 1
fi

source "$CONFIG_FILE"

if [ -z "$MEOW_THEME" ] || [ -z "$MEOW_SIZE" ]; then
    echo "Configuración incompleta. Ejecuta 'meow-colorscripts-setup' para configurarlo."
    exit 1
fi

LANGUAGE="en"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

print_msg() {
    # Uso: print_msg "mensaje en español" "message in English"
    if [ "$LANGUAGE" = "es" ]; then
        echo -e "$1"
    else
        echo -e "$2"
    fi
}

# Definir la carpeta de arte correctamente:
ART_DIR="$CONFIG_DIR/colorscripts/$MEOW_THEME/$MEOW_SIZE"
if [ ! -d "$ART_DIR" ]; then
    print_msg "La carpeta de arte \"$ART_DIR\" no existe." "Art folder \"$ART_DIR\" not found."
    exit 1
fi

# Función para mostrar el contenido del archivo usando echo -e
show_art() {
    local file="$1"
    echo -e "$(<"$file")"
}

if [ -n "$1" ]; then
    ART_FILE="$ART_DIR/$1.txt"
    if [ -f "$ART_FILE" ]; then
        show_art "$ART_FILE"
    else
        print_msg "No se encontró el arte para \"$1\"." "Art for \"$1\" not found."
        exit 1
    fi
else
    FILES=("$ART_DIR"/*.txt)
    if [ ${#FILES[@]} -eq 0 ]; then
        # Si no se encuentran archivos .txt, usar error.txt
        ERROR_FILE="$CONFIG_DIR/colorscripts/error.txt"
        if [ -f "$ERROR_FILE" ]; then
            show_art "$ERROR_FILE"
            exit 0
        else
            print_msg "No hay archivos de arte disponibles en \"$ART_DIR\" ni se encontró error.txt." \
                      "No art files found in \"$ART_DIR\" and error.txt not found."
            exit 1
        fi
    else
        RANDOM_FILE=${FILES[RANDOM % ${#FILES[@]}]}
        show_art "$RANDOM_FILE"
    fi
fi
