#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts (Versión MiauNord)
# ========================================================
# Este script instala meow-colorscripts con toque felino y paleta Nord:
# • Selecciona y guarda el idioma en ~/.config/meow-colorscripts/lang.
# • Clona el repositorio (si no existe) en ~/meow-colorscripts y mueve
#   la carpeta de configuración a ~/.config/meow-colorscripts.
# • Instala en ~/.local/bin los siguientes comandos:
#       - meow-colorscripts          (comando principal que muestra un meow random)
#       - meow-colorscripts-update   (desde update.sh)
#       - meow-colorscripts-setup    (desde setup.sh)
#       - meow-colorscripts-names    (muestra el contenido de names.txt)
#       - meow-colorscripts-show     (para mostrar arte ASCII específico)
# • Actualiza el PATH según la shell del usuario.
# • Muestra mensajes vibrantes usando la paleta Nord e invita a iniciar la configuración.
# ========================================================

export TERM=${TERM:-xterm-256color}

# --- Definición de la paleta Nord Aurora con ANSI escapes ---
NORD0="\033[38;2;46;52;64m"    # Fondo oscuro
NORD1="\033[38;2;59;66;82m"
NORD2="\033[38;2;67;76;94m"
NORD3="\033[38;2;76;86;106m"
NORD4="\033[38;2;216;222;233m"  # Texto claro principal
NORD5="\033[38;2;229;233;240m"
NORD6="\033[38;2;236;239;244m"
NORD7="\033[38;2;143;188;187m"  # Verde/acento
NORD8="\033[38;2;136;192;208m"  # Cian/acento
NORD9="\033[38;2;129;161;193m"  # Azul claro
NORD10="\033[38;2;94;129;172m"  # Azul oscuro

# Usamos la paleta Nord para nuestros mensajes:
GREEN="$NORD7"
RED="$NORD1"
YELLOW="$NORD9"
CYAN="$NORD8"
MAGENTA="$NORD10"
WHITE="$NORD4"
NC='\033[0m'  # Reset

# --- Función para reiniciar el script (en caso de necesitarlo) ---
restart_script() {
    printf "%b\n" "Reiniciando el instalador..."
    exec "$0" "$@"
}

# --- Función para mostrar mensajes felinos dinámicos con validación ---
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

# --- Directorios y archivos base ---
CONFIG_DIR="$HOME/.config/meow-colorscripts"
BIN_DIR="$HOME/.local/bin"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# ---------------------------------------
# 1. Selección de idioma y exportación a LANG
# ---------------------------------------
printf "\n${CYAN}▸ Select your language:${NC}\n"
printf "  ${YELLOW}1) Español${NC}\n"
printf "  ${YELLOW}2) English${NC}\n"
printf "${CYAN}▸ Choose an option [1/2]: ${NC}"
read LANG_OPTION
LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi
mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"
export LANG="$LANGUAGE"
printf "${GREEN}¡Idioma establecido!${NC}\n"

# ---------------------------------------
# 2. Clonar el repositorio y mover la carpeta de configuración
# ---------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
    printf "\n${YELLOW}▸ No se encontró $LOCAL_REPO. Clonando repositorio...${NC}\n"
    # Reemplaza la URL por la de tu repositorio:
    git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO" || {
        printf "${RED}✖ Error clonando el repositorio.${NC}\n"
        exit 1
    }
fi

# Asegurarse de que todos los scripts en el repositorio sean ejecutables
find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

# Mover la carpeta de configuración desde el repositorio a ~/.config/meow-colorscripts
if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    rm -f "$LOCAL_REPO/.config/meow-colorscripts/meow.conf" "$LOCAL_REPO/.config/meow-colorscripts/lang"
    rm -rf "$CONFIG_DIR" 2>/dev/null
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    print_dynamic_message "Carpeta miauctaida a $CONFIG_DIR"
else
    printf "\n${RED}✖ No se encontró la carpeta de configuración en el repositorio.${NC}\n"
fi

# ---------------------------------------
# 3. Instalación de comandos en ~/.local/bin
# ---------------------------------------
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

# ---------------------------------------
# 4. Instalar el comando PRINCIPAL: "meow-colorscripts"
#     (Muestra un meow RANDOM de la carpeta de arte según la configuración)
#     Se busca primero en $CONFIG_DIR; si no se encuentra, se usa $LOCAL_REPO.
# ---------------------------------------
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-colorscripts"
    print_dynamic_message "meow-colorscripts instalado"
elif [ -f "$LOCAL_REPO/show-meows.sh" ]; then
    install -Dm755 "$LOCAL_REPO/show-meows.sh" "$BIN_DIR/meow-colorscripts"
    print_dynamic_message "meow-colorscripts instalado"
else
    printf "\n${RED}✖ No se encontró 'show-meows.sh' para el comando principal.${NC}\n"
fi

# ---------------------------------------
# 5. Instalar comando "meow-colorscripts-update" (desde update.sh)
# ---------------------------------------
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/meow-colorscripts-update"
    print_dynamic_message "meow-colorscripts-update instalado"
else
    printf "\n${RED}✖ No se encontró update.sh en el repositorio.${NC}\n"
fi

# ---------------------------------------
# 6. Instalar comando "meow-colorscripts-setup" (desde setup.sh)
# ---------------------------------------
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$BIN_DIR/meow-colorscripts-setup"
    print_dynamic_message "meow-colorscripts-setup instalado"
else
    printf "\n${RED}✖ No se encontró setup.sh en el repositorio.${NC}\n"
fi

# ---------------------------------------
# 7. Instalar comando "meow-colorscripts-names" (muestra el contenido de names.txt)
# ---------------------------------------
{
  echo "#!/bin/bash"
  echo "cat $CONFIG_DIR/names.txt"
} > "$BIN_DIR/meow-colorscripts-names"
chmod +x "$BIN_DIR/meow-colorscripts-names"
print_dynamic_message "meow-colorscripts-names instalado"

# ---------------------------------------
# 8. Instalar comando "meow-colorscripts-show" (para mostrar arte ASCII específico)
#     Se busca primero en $CONFIG_DIR; si no se encuentra, se revisa en $LOCAL_REPO.
# ---------------------------------------
if [ -f "$CONFIG_DIR/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$CONFIG_DIR/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
    print_dynamic_message "meow-colorscripts-show instalado"
elif [ -f "$LOCAL_REPO/meow-colorscripts-show.sh" ]; then
    install -Dm755 "$LOCAL_REPO/meow-colorscripts-show.sh" "$BIN_DIR/meow-colorscripts-show"
    print_dynamic_message "meow-colorscripts-show instalado"
else
    printf "\n${RED}✖ No se encontró 'meow-colorscripts-show.sh'.${NC}\n"
fi

# ---------------------------------------
# 9. Mensaje final y pregunta para iniciar la configuración
# ---------------------------------------
printf "\n${YELLOW} Reinicia tu terminal para que los cambios surtan efecto.${NC}\n"
printf "${YELLOW}▸ ¿Deseas iniciar la configuración ahora? [s/n]: ${NC}"
read RUN_CONFIG
if [[ "$RUN_CONFIG" =~ ^[sS] ]]; then
    "$BIN_DIR/meow-colorscripts-setup"
fi

printf "\n${MAGENTA}¡Miau! Instalación completada exitosamente.${NC}\n"
chmod +x "$0"
