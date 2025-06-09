#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts
# ========================================================
# Este script instala meow-colorscripts siguiendo el proceso:
#   • Selección y guardado del idioma en ~/.config/meow-colorscripts/lang
#   • Verificación de dependencias (Git, fc-list, Nerd Fonts)
#   • Clonación del repositorio local (si no existe) y movimiento de la carpeta
#     de configuración (incluyendo "colorscripts") a ~/.config/meow-colorscripts
#   • Instalación de comandos en ~/.local/bin usando "install -Dm755"
#   • Actualización del PATH en función de la shell del usuario y exportación a LANG
#   • Frases de carga dinámicas (con puntitos) al instalar cada componente
#   • Pregunta para abrir la configuración (setup.sh)
#   • Mensaje final indicando que debes reiniciar la terminal para que funcione
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    echo "Reiniciando el instalador..."
    exec "$0" "$@"
}

# Función para mostrar mensajes con puntitos dinámicos y luego ""
print_dynamic_message() {
    local message="$1"
    local delay=0.3
    printf "%s" "$message"
    for i in {1..3}; do
         printf "."
         sleep $delay
    done
    printf " \n"
}

CONFIG_DIR="$HOME/.config/meow-colorscripts"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# Colores ANSI para salida
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# --------------------------------------------------------
# Selección de idioma y exportación a LANG
# --------------------------------------------------------
echo -e "${CYAN}Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
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
        echo -e "${RED}Git no está instalado.${NC}"
        read -p "¿Instalar Git automáticamente? (s/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" =~ ^[sS]$ ]]; then
            echo -e "${CYAN}Instalando Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            [ $? -eq 0 ] && { echo -e "${GREEN}Git instalado.${NC}"; restart_script "$@"; } || { echo -e "${RED}Error al instalar Git.${NC}"; exit 1; }
        else
            echo -e "${RED}Git es necesario. Instálalo manualmente y reejecuta.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Git is not installed.${NC}"
        read -p "Install Git automatically? (y/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" =~ ^[yY]$ ]]; then
            echo -e "${CYAN}Installing Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            [ $? -eq 0 ] && { echo -e "${GREEN}Git installed.${NC}"; restart_script "$@"; } || { echo -e "${RED}Error installing Git.${NC}"; exit 1; }
        else
            echo -e "${RED}Git is required. Please install it manually and rerun.${NC}"
            exit 1
        fi
    fi
fi

if ! command -v fc-list &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}fc-list no está instalado. Instala fontconfig (ej.: 'sudo apt install fontconfig') e inténtalo.${NC}"
    else
        echo -e "${RED}fc-list is not installed. Please install fontconfig and try again.${NC}"
    fi
    exit 1
fi

NERD_FONT_INSTALLED=$(fc-list | grep -i "Nerd")
if [ -z "$NERD_FONT_INSTALLED" ]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}No se detectaron Nerd Fonts instaladas.${NC}"
        read -p "¿Instalar Nerd Fonts? (s/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" =~ ^[sS]$ ]]; then
            echo -e "${CYAN}Instalando Nerd Fonts...${NC}"
        else
            echo -e "${RED}Continuando sin Nerd Fonts. La visualización puede sufrir.${NC}"
        fi
    else
        echo -e "${RED}No Nerd Fonts detected.${NC}"
        read -p "Install Nerd Fonts? (y/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" =~ ^[yY]$ ]]; then
            echo -e "${CYAN}Installing Nerd Fonts...${NC}"
        else
            echo -e "${RED}Continuing without Nerd Fonts. Display might be affected.${NC}"
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
                echo -e "${GREEN}Nerd Fonts instaladas. Reinicia la terminal.${NC}"
            else
                echo -e "${GREEN}Nerd Fonts installed. Please restart your terminal.${NC}"
            fi
        else
            if [[ "$LANGUAGE" == "es" ]]; then
                echo -e "${RED}Error clonando Nerd Fonts.${NC}"
            else
                echo -e "${RED}Error cloning Nerd Fonts repository.${NC}"
            fi
            exit 1
        fi
    fi
fi

# --------------------------------------------------------
# Instalación del repositorio y configuración local
# --------------------------------------------------------
if [ ! -d "$LOCAL_REPO" ]; then
    echo -e "${YELLOW}No se encontró $LOCAL_REPO. Clonando repositorio...${NC}"
    # Reemplaza la siguiente URL con la de tu repositorio
    git clone https://github.com/tu_usuario/tu_repositorio.git "$LOCAL_REPO" \
        || { echo -e "${RED}Error clonando el repositorio.${NC}"; exit 1; }
fi

find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    rm -rf "$CONFIG_DIR"
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    print_dynamic_message "Carpeta de configuración movida a $CONFIG_DIR"
else
    echo -e "${YELLOW}No se encontró carpeta de configuración en el repositorio.${NC}"
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
            echo -e "\nPATH actualizado en ~/.bashrc"
            ;;
        zsh)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            echo -e "\nPATH actualizado en ~/.zshrc"
            ;;
        *)
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.profile"
            echo -e "\nPATH actualizado en ~/.profile"
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
        echo -e "${RED}Error: show-meows.sh no se encontró en $CONFIG_DIR.${NC}"
    else
        echo -e "${RED}Error: show-meows.sh not found in $CONFIG_DIR.${NC}"
    fi
fi

# Instalar meow-update (si existe update.sh)
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$HOME/.local/bin/meow-update"
    print_dynamic_message "Comando meow-update instalado correctamente"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}Error: update.sh no se encontró en el repositorio local.${NC}"
    else
        echo -e "${RED}Error: update.sh not found in the local repository.${NC}"
    fi
fi

# Instalar meow-colorscripts-setup (para ejecutar setup.sh)
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$HOME/.local/bin/meow-colorscripts-setup"
    print_dynamic_message "Comando meow-colorscripts-setup instalado correctamente"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}Error: setup.sh no se encontró en el repositorio local.${NC}"
    else
        echo -e "${RED}Error: setup.sh not found in the repository.${NC}"
    fi
fi

# --------------------------------------------------------
# Frases de carga felinas (opción dinámica)
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
    printf "%s" "$CYAN$RANDOM_MSG"
    for j in {1..3}; do 
        printf "."
        sleep 0.3
    done
    printf " %s\n" "${GREEN}OK${NC}"
done

# --------------------------------------------------------
# Preguntar si se desea abrir la configuración ahora
# --------------------------------------------------------
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\nOpen configuration now?"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "Selecciona una opción [s/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[sS]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
else
    echo -e "\nOpen configuration now?"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "Select an option [y/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[yY]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
fi

# --------------------------------------------------------
# Mensaje final: Reinicia la terminal para que los cambios surtan efecto
# --------------------------------------------------------
printf "\n%s Reanuda (reinicia) tu terminal para que los cambios surtan efecto.\n" ""

echo -e "\nInstalación completada."
