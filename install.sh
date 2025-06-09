#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts (versión felina minimalista)
# ========================================================
# Este script instala meow-colorscripts:
# • Permite seleccionar y guardar el idioma en ~/.config/meow-colorscripts/lang.
# • Verifica dependencias (Git, fc-list, Nerd Fonts).
# • Clona el repositorio (si no existe) en ~/meow-colorscripts y, si se encuentra 
#   la carpeta de configuración en ~/meow-colorscripts/.config/meow-colorscripts,
#   elimina los archivos meow.conf y lang para preservar la configuración actual del usuario,
#   y mueve la carpeta a ~/.config/meow-colorscripts.
# • Instala en ~/.local/bin los siguientes comandos, renombrados con el prefijo:
#       - meow-colorscripts-update   (desde update.sh)
#       - meow-colorscripts-setup    (desde setup.sh)
#       - meow-colorscripts-show     (desde meow-colorscripts-show.sh)
# • Actualiza el PATH según la shell del usuario.
# • Muestra mensajes felinos y minimalistas (por ejemplo, "PATH miauctuaizado").
# • Al final, recuerda reiniciar la terminal e invita a iniciar la configuración.
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    printf "%b\n" "Reiniciando el instalador..."
    exec "$0" "$@"
}

# Función para mostrar mensajes felinos dinámicos con ícono de validación
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

# Directorios y archivos
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
# Selección de idioma y exportación a LANG
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
# Clonar el repositorio y mover la carpeta de configuración
# --------------------------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
    printf "%b\n" "${YELLOW}No se encontró $LOCAL_REPO. Clonando repositorio...${NC}"
    # Cambia la URL de clonación por la de tu repositorio:
    git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO" || { printf "%b\n" "${RED}Error clonando el repositorio.${NC}"; exit 1; }
fi

# Asegurar que todos los scripts sean ejecutables
find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

# Mover la carpeta de configuración (dejando intacto names.txt)
if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    rm -f "$LOCAL_REPO/.config/meow-colorscripts/meow.conf" "$LOCAL_REPO/.config/meow-colorscripts/lang"
    rm -rf "$CONFIG_DIR" 2>/dev/null
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    print_dynamic_message "Carpeta miauctaida a $CONFIG_DIR"
else
    printf "%b\n" "${YELLOW}No se encontró la carpeta de configuración en el repositorio.${NC}"
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

print_dynamic_message "PATH miauctuaizado"

# Instalar comando "meow-colorscripts-update" (desde update.sh)
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/meow-colorscripts-update"
    print_dynamic_message "meow-colorscripts-update instalado"
else
    printf "%b\n" "${YELLOW}No se encontró update.sh en el repositorio.${NC}"
fi

# Instalar comando "meow-colorscripts-setup" (desde setup.sh)
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$BIN_DIR/meow-colorscripts-setup"
    print_dynamic_message "meow-colorscripts-setup instalado"
else
    printf "%b\n" "${YELLOW}No se encontró setup.sh en el repositorio.${NC}"
fi

# Instalar comando "meow-colorscripts-show" (desde meow-colorscripts-show.sh)
if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
    print_dynamic_message "meow-colorscripts-show instalado"
elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
    print_dynamic_message "meow-colorscripts-show instalado"
else
    printf "%b\n" "${YELLOW}No se encontró 'meow-colorscripts-show.sh'.${NC}"
fi

# --------------------------------------------------------
# Mensaje final y pregunta para iniciar la configuración
# --------------------------------------------------------
printf "\n\033[1;33m Reinicia tu terminal para que los cambios surtan efecto.\033[0m\n"
read -p "$(printf "\033[1;33m¿Deseas iniciar la configuración ahora? [s/n]: \033[0m")" RUN_CONFIG
if [[ "$RUN_CONFIG" =~ ^[sS] ]]; then
    "$BIN_DIR/meow-colorscripts-setup"
fi

printf "\n%b\n" "Instalación completada."
chmod +x "$0"
