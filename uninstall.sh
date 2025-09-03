#!/bin/bash

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


if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n Iniciando desinstalación de meow-colorscripts..."
else
    echo -e "\n Starting uninstallation of meow-colorscripts..."
fi


if [[ "$LANGUAGE" == "es" ]]; then
    ask_confirmation "¿Estás seguro de que deseas desinstalar meow-colorscripts?"
else
    ask_confirmation "Are you sure you want to uninstall meow-colorscripts?"
fi


BIN_DIR="$HOME/.local/bin"
if ls "$BIN_DIR"/*meow* 1> /dev/null 2>&1; then
    for file in "$BIN_DIR"/*meow*; do
        if [ -f "$file" ]; then
            rm "$file"
            if [[ "$LANGUAGE" == "es" ]]; then
                echo -e " Se eliminó el comando $(basename "$file")."
            else
                echo -e " Removed command $(basename "$file")."
            fi
        fi
    done
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " No se encontraron comandos con 'meow' en su nombre en $BIN_DIR."
    else
        echo -e " No commands with 'meow' in their name found in $BIN_DIR."
    fi
fi


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


if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n Desinstalación completada."
    echo -e " Revisa tu archivo .bashrc o .zshrc y elimina la línea que agrega ~/.local/bin al PATH, si así lo deseas."
else
    echo -e "\n Uninstallation completed."
    echo -e " Check your .bashrc or .zshrc file to remove the line that adds ~/.local/bin to the PATH if desired."
fi
