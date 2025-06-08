#!/bin/bash
# ========================================================
# Uninstall de meow-colorscripts
# ========================================================
# Este script desinstala meow-colorscripts y elimina los
# comandos instalados en ~/.local/bin:
#   - meow-colorscripts
#   - meow-update
#   - meow-colorscripts-setup
#   - (si existen) meow-show y meows-names.
#
# También elimina la carpeta de configuración en ~/.config/meow-colorscripts
# y la carpeta del repositorio local ~/meow-colorscripts.
#
# El script utiliza el idioma configurado en el proceso de instalación,
# leyendo el archivo $HOME/.config/meow-colorscripts/lang (si existe).
# De lo contrario, asume inglés.
# ========================================================

# Detectar el idioma configurado (si está)
LANGUAGE="en"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"
if [ -f "$LANG_FILE" ]; then
    LANGUAGE=$(cat "$LANG_FILE")
fi

# Función para solicitar confirmación (usa mensajes según idioma)
ask_confirmation() {
    if [[ "$LANGUAGE" == "es" ]]; then
        read -p "$1 [s/n]: " RESPONSE
        if [[ "$RESPONSE" != "s" && "$RESPONSE" != "S" ]]; then
            echo "Desinstalación cancelada."
            exit 0
        fi
    else
        read -p "$1 [y/n]: " RESPONSE
        if [[ "$RESPONSE" != "y" && "$RESPONSE" != "Y" ]]; then
            echo "Uninstallation cancelled."
            exit 0
        fi
    fi
}

# Mensaje de inicio según idioma
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n Iniciando desinstalación de meow-colorscripts..."
else
    echo -e "\n Starting uninstallation of meow-colorscripts..."
fi

# Preguntar confirmación
if [[ "$LANGUAGE" == "es" ]]; then
    ask_confirmation "¿Estás seguro de que deseas desinstalar meow-colorscripts?"
else
    ask_confirmation "Are you sure you want to uninstall meow-colorscripts?"
fi

# Definir la lista de comandos instalados en ~/.local/bin
BIN_DIR="$HOME/.local/bin"
COMMANDS=("meow-colorscripts" "meow-update" "meow-colorscripts-setup" "meow-show" "meows-names")
for cmd in "${COMMANDS[@]}"; do
    FILE="$BIN_DIR/$cmd"
    if [ -f "$FILE" ]; then
        rm "$FILE"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e " Se eliminó el comando $cmd."
        else
            echo -e " Removed command $cmd."
        fi
    else
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e " No se encontró el comando $cmd (quizás ya haya sido eliminado)."
        else
            echo -e " Command $cmd not found (maybe already removed)."
        fi
    fi
done

# Eliminar la carpeta de configuración en ~/.config/meow-colorscripts
CONFIG_DIR="$HOME/.config/meow-colorscripts"
if [ -d "$CONFIG_DIR" ]; then
    rm -rf "$CONFIG_DIR"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " Se eliminó la carpeta de configuración: $CONFIG_DIR"
    else
        echo -e " Removed configuration folder: $CONFIG_DIR"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " No se encontró la carpeta de configuración."
    else
        echo -e " Configuration folder not found."
    fi
fi

# Eliminar la carpeta del repositorio local ~/meow-colorscripts
LOCAL_REPO="$HOME/meow-colorscripts"
if [ -d "$LOCAL_REPO" ]; then
    rm -rf "$LOCAL_REPO"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " Se eliminó el directorio del repositorio: $LOCAL_REPO"
    else
        echo -e " Removed repository directory: $LOCAL_REPO"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " No se encontró el directorio del repositorio."
    else
        echo -e " Repository directory not found."
    fi
fi

# Recordatorio para revisar el archivo de configuración del shell
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n Desinstalación completada."
    echo -e " Revisa tu archivo .bashrc o .zshrc y elimina la línea que agrega ~/.local/bin al PATH, si así lo deseas."
else
    echo -e "\n Uninstallation completed."
    echo -e " Check your .bashrc or .zshrc file to remove the line that adds ~/.local/bin to the PATH if desired."
fi

