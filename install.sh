#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts
# ========================================================
# Este script instala meow-colorscripts siguiendo el proceso:
#   • Selección y guardado del idioma en ~/.config/meow-colorscripts/lang
#   • Verificación de dependencias (Git, fc-list, Nerd Fonts)
#   • Clonación del repositorio local (si no existe) y movimiento de la
#     carpeta de configuración (incluyendo "colorscripts")
#     a ~/.config/meow-colorscripts
#   • Instalación de comandos en ~/.local/bin usando "install -Dm755":
#         - meow-colorscripts (basado en show-meows.sh)
#         - meow-update (si existe update.sh)
#         - meow-colorscripts-setup (para ejecutar setup.sh)
#   • Los comandos de nombres (`meows-names` y `meow-show`) **se activan en setup.sh**.
#   • Actualización del `PATH` según la shell del usuario y exportación del idioma a `LANG`
#   • Mensajes dinámicos en las acciones importantes
#   • Pregunta para abrir la configuración (setup.sh)
#   • Mensaje final indicando que debes reiniciar la terminal para que los cambios surtan efecto.
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    printf "%b\n" "Reiniciando el instalador..."
    exec "$0" "$@"
}

# Función para mostrar mensajes dinámicos: imprime la cadena, luego puntitos y al final ""
print_dynamic_message() {
    local message="$1"
    local delay=0.3
    printf "%b" "$message"
    for i in {1..3}; do
         printf "."
         sleep $delay
    done
    printf " %b\n" "${GREEN}${NC}"
}

CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# Colores ANSI
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# --------------------------------------------------------
# Selección de idioma y exportación a `LANG`
# --------------------------------------------------------
printf "%b\n" "${CYAN}Select your language:${NC}"
printf "%b\n" "  1) Español"
printf "%b\n" "  2) English"
read -p "Choose an option [1/2]: " LANG_OPTION
LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi
mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"
export LANG="$LANGUAGE"

# --------------------------------------------------------
# Instalación del repositorio y configuración local
# --------------------------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
    printf "%b\n" "${YELLOW}No se encontró $LOCAL_REPO. Clonando repositorio...${NC}"
    # REEMPLAZA la siguiente URL por la de tu repositorio.
    git clone https://github.com/tu_usuario/tu_repositorio.git "$LOCAL_REPO" || { printf "%b\n" "${RED}Error clonando el repositorio.${NC}"; exit 1; }
fi

find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    rm -rf "$CONFIG_DIR"
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    print_dynamic_message "Carpeta de configuración movida a $CONFIG_DIR"
else
    printf "%b\n" "${YELLOW}No se encontró carpeta de configuración en el repositorio.${NC}"
fi

# --------------------------------------------------------
# Instalación de comandos en ~/.local/bin
# --------------------------------------------------------
mkdir -p "$BIN_DIR"

if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
    CURRENT_SHELL=$(basename "$SHELL")
    case "$CURRENT_SHELL" in
        bash)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            ;;
        zsh)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            ;;
        *)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
            ;;
    esac
    export PATH="$BIN_DIR:$PATH"
fi

print_dynamic_message "PATH actualizado"

# Instalar `meow-colorscripts`
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-colorscripts"
    print_dynamic_message "Comando meow-colorscripts instalado correctamente"
fi

# Instalar `meow-update` (si existe `update.sh`)
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/meow-update"
    print_dynamic_message "Comando meow-update instalado correctamente"
fi

# Instalar `meow-colorscripts-setup`
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$BIN_DIR/meow-colorscripts-setup"
    print_dynamic_message "Comando meow-colorscripts-setup instalado correctamente"
fi

#hacer ejecutable meow-show.sh
chmod +x $HOME/meow-colorscipts/meow-show.sh

# --------------------------------------------------------
# Preguntar si se desea abrir la configuración ahora
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    printf "\n%b\n" "${CYAN}¿Deseas abrir la configuración ahora?${NC}"
    printf "%b\n" "  s) Sí"
    printf "%b\n" "  n) No"
    read -p "Selecciona una opción [s/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[sS]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
else
    printf "\n%b\n" "${CYAN}Do you want to open the configuration now?${NC}"
    printf "%b\n" "  y) Yes"
    printf "%b\n" "  n) No"
    read -p "Select an option [y/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[yY]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
fi

# --------------------------------------------------------
# Mensaje final: Reinicia la terminal para que los cambios surtan efecto
# --------------------------------------------------------
printf "\n%b Reanuda (reinicia) tu terminal para que los cambios surtan efecto.\n" ""
printf "\n%b\n" "Instalación completada."
