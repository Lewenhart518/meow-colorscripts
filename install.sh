#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts (Versión MiauColor Plus)
# ========================================================
# Este script instala meow-colorscripts con toque felino:
# • Permite seleccionar y guardar el idioma en ~/.config/meow-colorscripts/lang.
# • Clona el repositorio (si no existe) en ~/meow-colorscripts y mueve la carpeta
#   de configuración a ~/.config/meow-colorscripts (dejando intacto names.txt).
# • Instala en ~/.local/bin los siguientes comandos:
#       - meow-colorscripts          (comando principal que muestra un meow random)
#       - meow-colorscripts-update   (desde update.sh)
#       - meow-colorscripts-setup    (desde setup.sh)
#       - meow-colorscripts-names    (muestra el contenido de names.txt)
#       - meow-colorscripts-show     (para mostrar meows específicos)
# • Actualiza el PATH según la shell del usuario.
# • Presenta mensajes vivos, coloridos y felinos, e invita a iniciar la configuración.
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    printf "%b\n" "Reiniciando el instalador..."
    exec "$0" "$@"
}

# Función para mostrar mensajes felinos dinámicos con ícono de validación
print_dynamic_message() {
    local message="$1"
    local delay=0.2
    printf "%b" "${MAGENTA}${message}${NC}"
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

# Definición de colores ANSI
GREEN='\033[38;2;60;179;113m'       # SeaGreen
RED='\033[38;2;220;20;60m'           # Crimson
YELLOW='\033[38;2;255;215;0m'        # Gold
CYAN='\033[38;2;0;206;209m'          # DarkTurquoise
MAGENTA='\033[38;2;218;112;214m'
BLUE='\033[38;2;65;105;225m'         # RoyalBlue
WHITE='\033[38;2;245;245;245m'
NC='\033[0m'                        # Reset

# --------------------------------------------------------
# Selección de idioma y exportación a LANG
# --------------------------------------------------------
printf "\n${CYAN}▸ Select your language:${NC}\n"
printf "  ${YELLOW}1) Español${NC}\n"
printf "  ${YELLOW}2) English${NC}\n"
read -p "${BLUE}▸ Choose an option [1/2]: ${NC}" LANG_OPTION
LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi
mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"
export LANG="$LANGUAGE"
printf "${GREEN}¡Idioma establecido!${NC}\n"

# --------------------------------------------------------
# Clonar el repositorio y mover la carpeta de configuración
# --------------------------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
    printf "\n${YELLOW}▸ No se encontró $LOCAL_REPO. Clonando repositorio...${NC}\n"
    # Cambia la URL por la de tu repositorio:
    git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO" || { printf "${RED}✖ Error clonando el repositorio.${NC}\n"; exit 1; }
fi

# Asegurarse que todos los scripts sean ejecutables
find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

# Mover la carpeta de configuración (dejando intacto names.txt)
if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    rm -f "$LOCAL_REPO/.config/meow-colorscripts/meow.conf" "$LOCAL_REPO/.config/meow-colorscripts/lang"
    rm -rf "$CONFIG_DIR" 2>/dev/null
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    print_dynamic_message "Carpeta miauctaida a $CONFIG_DIR"
else
    printf "\n${RED}✖ No se encontró la carpeta de configuración en el repositorio.${NC}\n"
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

# --------------------------------------------------------
# Instalar comando PRINCIPAL "meow-colorscripts"
# (Muestra un meow RANDOM según el estilo/tamaño configurado)
# Se busca primero en $CONFIG_DIR y de no hallarse en $LOCAL_REPO
# --------------------------------------------------------
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-colorscripts"
    print_dynamic_message "meow-colorscripts instalado"
elif [ -f "$LOCAL_REPO/show-meows.sh" ]; then
    install -Dm755 "$LOCAL_REPO/show-meows.sh" "$BIN_DIR/meow-colorscripts"
    print_dynamic_message "meow-colorscripts instalado"
else
    printf "\n${RED}✖ No se encontró 'show-meows.sh' para el comando principal.${NC}\n"
fi

# --------------------------------------------------------
# Instalar comando "meow-colorscripts-update" (desde update.sh)
# --------------------------------------------------------
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/meow-colorscripts-update"
    print_dynamic_message "meow-colorscripts-update instalado"
else
    printf "\n${RED}✖ No se encontró update.sh en el repositorio.${NC}\n"
fi

# --------------------------------------------------------
# Instalar comando "meow-colorscripts-setup" (desde setup.sh)
# --------------------------------------------------------
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$BIN_DIR/meow-colorscripts-setup"
    print_dynamic_message "meow-colorscripts-setup instalado"
else
    printf "\n${RED}✖ No se encontró setup.sh en el repositorio.${NC}\n"
fi

# --------------------------------------------------------
# Instalar comando "meow-colorscripts-names" (muestra names.txt)
# --------------------------------------------------------
{
  echo "#!/bin/bash"
  echo "cat $CONFIG_DIR/names.txt"
} > "$BIN_DIR/meow-colorscripts-names"
chmod +x "$BIN_DIR/meow-colorscripts-names"
print_dynamic_message "meow-colorscripts-names instalado"

# --------------------------------------------------------
# Instalar comando "meow-colorscripts-show" (para meows específicos)
# Se busca primero en $CONFIG_DIR, de lo contrario en $LOCAL_REPO
# --------------------------------------------------------
if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
    print_dynamic_message "meow-colorscripts-show instalado"
elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
    print_dynamic_message "meow-colorscripts-show instalado"
else
    printf "\n${RED}✖ No se encontró 'meow-colorscripts-show.sh'.${NC}\n"
fi

# --------------------------------------------------------
# Mensaje final y pregunta para iniciar la configuración
# --------------------------------------------------------
printf "\n${YELLOW} Reinicia tu terminal para que los cambios surtan efecto.${NC}\n"
read -r -p "$(echo -e "${YELLOW}▸ ¿Deseas iniciar la configuración ahora? [s/n]: ${NC}")" RUN_CONFIG
if [[ "$RUN_CONFIG" =~ ^[sS] ]]; then
    "$BIN_DIR/meow-colorscripts-setup"
fi

printf "\n${MAGENTA}¡Miau! Instalación completada exitosamente.${NC}\n"
chmod +x "$0"

