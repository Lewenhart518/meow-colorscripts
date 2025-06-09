#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts
# ========================================================
# Este script instala meow-colorscripts siguiendo el proceso:
#   • Selección y guardado del idioma en ~/.config/meow-colorscripts/lang
#   • Verificación de dependencias (Git, fc-list, Nerd Fonts)
#   • Clonación del repositorio local (si no existe) y movimiento de la
#     carpeta de configuración (incluyendo "colorscripts") a ~/.config/meow-colorscripts
#   • Instalación de comandos en ~/.local/bin usando "install -Dm755"
#   • Actualización del PATH según la shell del usuario y exportación del idioma a LANG
#   • Mensajes dinámicos (con puntitos) en las acciones importantes
#   • Pregunta para abrir la configuración (setup.sh)
#   • Mensaje final indicando que debes reiniciar la terminal para que los cambios surtan efecto.
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    printf "%b\n" "Reiniciando el instalador..."
    exec "$0" "$@"
}

# Función para mostrar mensajes dinámicos: recibe la cadena a mostrar y, al final, imprime ""
print_dynamic_message() {
    local message="$1"
    local delay=0.3
    # Imprime la cadena interpretando escapes ANSI
    printf "%b" "$message"
    for i in {1..3}; do
         printf "."
         sleep $delay
    done
    printf " %b\n" "${GREEN}${NC}"
}

CONFIG_DIR="$HOME/.config/meow-colorscripts"
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
# Verificar dependencias
# --------------------------------------------------------
if ! command -v git &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "%b\n" "${RED}Git no está instalado.${NC}"
        read -p "¿Instalar Git automáticamente? (s/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" =~ ^[sS]$ ]]; then
            printf "%b\n" "${CYAN}Instalando Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            [ $? -eq 0 ] && { printf "%b\n" "${GREEN}Git instalado.${NC}"; restart_script "$@"; } \
                || { printf "%b\n" "${RED}Error al instalar Git.${NC}"; exit 1; }
        else
            printf "%b\n" "${RED}Git es necesario. Instálalo manualmente y reejecuta.${NC}"
            exit 1
        fi
    else
        printf "%b\n" "${RED}Git is not installed.${NC}"
        read -p "Install Git automatically? (y/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" =~ ^[yY]$ ]]; then
            printf "%b\n" "${CYAN}Installing Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            [ $? -eq 0 ] && { printf "%b\n" "${GREEN}Git installed.${NC}"; restart_script "$@"; } \
                || { printf "%b\n" "${RED}Error installing Git.${NC}"; exit 1; }
        else
            printf "%b\n" "${RED}Git is required. Please install it manually and rerun.${NC}"
            exit 1
        fi
    fi
fi

if ! command -v fc-list &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "%b\n" "${RED}fc-list no está instalado. Instala fontconfig (ej.: 'sudo apt install fontconfig') e inténtalo.${NC}"
    else
        printf "%b\n" "${RED}fc-list is not installed. Please install fontconfig and try again.${NC}"
    fi
    exit 1
fi

NERD_FONT_INSTALLED=$(fc-list | grep -i "Nerd")
if [ -z "$NERD_FONT_INSTALLED" ]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "%b\n" "${RED}No se detectaron Nerd Fonts instaladas.${NC}"
        read -p "¿Instalar Nerd Fonts? (s/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" =~ ^[sS]$ ]]; then
            printf "%b\n" "${CYAN}Instalando Nerd Fonts...${NC}"
        else
            printf "%b\n" "${RED}Continuando sin Nerd Fonts. La visualización puede sufrir.${NC}"
        fi
    else
        printf "%b\n" "${RED}No Nerd Fonts detected.${NC}"
        read -p "Install Nerd Fonts? (y/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" =~ ^[yY]$ ]]; then
            printf "%b\n" "${CYAN}Installing Nerd Fonts...${NC}"
        else
            printf "%b\n" "${RED}Continuing without Nerd Fonts. Display might be affected.${NC}"
        fi
    fi

    if [[ "$INSTALL_NERD" =~ ^[sSyY]$ ]]; then
        git clone https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts
        if [ $? -eq 0 ]; then
            cd /tmp/nerd-fonts || exit
            ./install.sh
            cd - > /dev/null
            rm -rf /tmp/nerd-fonts
            if [[ "$LANGUAGE" == "es" ]]; then
                printf "%b\n" "${GREEN}Nerd Fonts instaladas. Reinicia la terminal.${NC}"
            else
                printf "%b\n" "${GREEN}Nerd Fonts installed. Please restart your terminal.${NC}"
            fi
        else
            if [[ "$LANGUAGE" == "es" ]]; then
                printf "%b\n" "${RED}Error clonando Nerd Fonts.${NC}"
            else
                printf "%b\n" "${RED}Error cloning Nerd Fonts repository.${NC}"
            fi
            exit 1
        fi
    fi
fi

# --------------------------------------------------------
# Instalación del repositorio y configuración local
# --------------------------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
    printf "%b\n" "${YELLOW}No se encontró $LOCAL_REPO. Clonando repositorio...${NC}"
    # REEMPLAZA la siguiente URL por la de tu repositorio.
    git clone https://github.com/tu_usuario/tu_repositorio.git "$LOCAL_REPO" \
        || { printf "%b\n" "${RED}Error clonando el repositorio.${NC}"; exit 1; }
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
mkdir -p "$HOME/.local/bin"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    CURRENT_SHELL=$(basename "$SHELL")
    case "$CURRENT_SHELL" in
        bash)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
            printf "\n%b\n" "PATH actualizado en ~/.bashrc"
            ;;
        zsh)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            printf "\n%b\n" "PATH actualizado en ~/.zshrc"
            ;;
        *)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
            printf "\n%b\n" "PATH actualizado en ~/.profile"
            ;;
    esac
    export PATH="$HOME/.local/bin:$PATH"
fi

# Instalar meow-colorscripts (basado en show-meows.sh)
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$HOME/.local/bin/meow-colorscripts"
    print_dynamic_message "Comando meow-colorscripts instalado correctamente"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "%b\n" "${RED}Error: show-meows.sh no se encontró en $CONFIG_DIR.${NC}"
    else
        printf "%b\n" "${RED}Error: show-meows.sh not found in $CONFIG_DIR.${NC}"
    fi
fi

# Instalar meow-update (si existe update.sh)
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$HOME/.local/bin/meow-update"
    print_dynamic_message "Comando meow-update instalado correctamente"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "%b\n" "${RED}Error: update.sh no se encontró en el repositorio local.${NC}"
    else
        printf "%b\n" "${RED}Error: update.sh not found in the local repository.${NC}"
    fi
fi

# Instalar meow-colorscripts-setup (para ejecutar setup.sh)
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$HOME/.local/bin/meow-colorscripts-setup"
    print_dynamic_message "Comando meow-colorscripts-setup instalado correctamente"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        printf "%b\n" "${RED}Error: setup.sh no se encontró en el repositorio local.${NC}"
    else
        printf "%b\n" "${RED}Error: setup.sh not found in the repository.${NC}"
    fi
fi

# --------------------------------------------------------
# Frases de carga felina (dinámicas)
# --------------------------------------------------------
LOADING_MSGS_ES=("Los gatos se estiran" "Acomodando almohadillas" "Afinando maullidos" "Ronroneo en progreso" "Explorando el código")
LOADING_MSGS_EN=("The cats are stretching" "Adjusting paw pads" "Fine-tuning meows" "Purring in progress" "Exploring the code")
LOADING_USED=()
for i in {1..3}; do 
    while true; do
        if [[ "$LANGUAGE" == "es" ]]; then
            RANDOM_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
        else
            RANDOM_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
        fi
        if [[ ! " ${LOADING_USED[@]} " =~ " $RANDOM_MSG " ]]; then
            LOADING_USED+=("$RANDOM_MSG")
            break
        fi
    done
    printf "%b" "$CYAN$RANDOM_MSG"
    for j in {1..3}; do 
         printf "."
         sleep 0.3
    done
    printf " %b\n" "${GREEN}OK${NC}"
done

# --------------------------------------------------------
# Preguntar si se desea abrir la configuración ahora
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    printf "\n%b\n" "${CYAN}Open configuration now?${NC}"
    printf "%b\n" "  s) Sí"
    printf "%b\n" "  n) No"
    read -p "Selecciona una opción [s/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[sS]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
else
    printf "\n%b\n" "${CYAN}Open configuration now?${NC}"
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
