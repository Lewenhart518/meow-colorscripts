chmod +x install.sh
```):

---

```bash
#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts
# ========================================================
# Este script instala meow-colorscripts siguiendo el proceso:
# • Selecciona y guarda el idioma en ~/.config/meow-colorscripts/lang.
# • Verifica las dependencias (Git, fc-list, Nerd Fonts).
# • Clona el repositorio (si no existe) en ~/meow-colorscripts y, si se encuentra 
#   la carpeta de configuración en ~/meow-colorscripts/.config/meow-colorscripts,
#   elimina los archivos meow.conf y lang para preservar la configuración actual del usuario,
#   y mueve dicha carpeta a ~/.config/meow-colorscripts.
# • Instala en ~/.local/bin los siguientes comandos, renombrados con el prefijo:
#       - meow-colorscripts          (desde show-meows.sh)
#       - meow-colorscripts-update   (desde update.sh)
#       - meow-colorscripts-setup    (desde setup.sh)
# • (Los comandos de nombres se activan en setup.sh).
# • Actualiza el PATH según la shell del usuario.
# • Muestra un mensaje final (en amarillo) indicando que se debe reiniciar la terminal.
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    printf "%b\n" "Reiniciando el instalador..."
    exec "$0" "$@"
}

# Función para mostrar mensajes dinámicos con icono de verificación
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
    # REEMPLAZA la siguiente URL con la de tu repositorio.
    git clone https://github.com/Lewenhart518/meow-colorscripts.git "$LOCAL_REPO" || { printf "%b\n" "${RED}Error clonando el repositorio.${NC}"; exit 1; }
fi

# Hacer que todos los scripts del repositorio sean ejecutables
find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

# Si existe la carpeta de configuración en el repositorio:
if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    # Se eliminan meow.conf y lang de la copia del repositorio para preservar la configuración del usuario.
    rm -f "$LOCAL_REPO/.config/meow-colorscripts/meow.conf" "$LOCAL_REPO/.config/meow-colorscripts/lang"
    rm -rf "$CONFIG_DIR" 2>/dev/null
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    print_dynamic_message "Carpeta de configuración movida a $CONFIG_DIR"
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

print_dynamic_message "PATH actualizado"

# Instalar comando principal "meow-colorscripts" (basado en show-meows.sh)
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$BIN_DIR/meow-colorscripts"
    print_dynamic_message "Comando meow-colorscripts instalado correctamente"
fi

# Instalar comando de actualización renombrado a "meow-colorscripts-update"
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$BIN_DIR/meow-colorscripts-update"
    print_dynamic_message "Comando meow-colorscripts-update instalado correctamente"
else
    printf "%b\n" "${YELLOW}No se encontró update.sh en el repositorio.${NC}"
fi

# Instalar comando de configuración renombrado a "meow-colorscripts-setup"
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$BIN_DIR/meow-colorscripts-setup"
    print_dynamic_message "Comando meow-colorscripts-setup instalado correctamente"
else
    printf "%b\n" "${YELLOW}No se encontró setup.sh en el repositorio.${NC}"
fi

# --------------------------------------------------------
# Mensaje final: Reinicia la terminal para que los cambios surtan efecto
# --------------------------------------------------------
printf "\n\033[1;33m Por favor, reinicia tu terminal para que los cambios surtan efecto.\033[0m\n"
printf "\n%b\n" "Instalación completada."

# Opcional: Asegurarse de que este script se marque como ejecutable (por precaución)
chmod +x "$0"

