#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts
# ========================================================
# Este script instala meow-colorscripts ejecutando:
# • Selección y guardado del idioma en ~/.config/meow-colorscripts/lang
# • Verificación de dependencias (Git, fc-list, Nerd Fonts)
# • Clonación del repositorio local (si no existe)
# • Movimiento de la carpeta de configuración (incluyendo "colorscripts")
# • Instalación de comandos en ~/.local/bin usando install -Dm755
# • Frases de carga felinas durante el proceso
# • Pregunta final para abrir la configuración (setup.sh)
# ========================================================

export TERM=${TERM:-xterm-256color}

restart_script() {
    echo " Reiniciando el instalador..."
    exec "$0" "$@"
}

CONFIG_DIR="$HOME/.config/meow-colorscripts"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# Colores ANSI (24 bits)
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# --- Selección de idioma ---
echo -e "${CYAN} Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
read -p "󰏩 Choose an option [1/2]: " LANG_OPTION
LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi

mkdir -p "$CONFIG_DIR"
echo "$LANGUAGE" > "$CONFIG_DIR/lang"

# --- Verificar dependencias ---
if ! command -v git &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Git no está instalado.${NC}"
        read -p "󰏩 ¿Instalar Git automáticamente? (s/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" =~ ^[sS]$ ]]; then
            echo -e "${CYAN} Instalando Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            [ $? -eq 0 ] && { echo -e "${GREEN} Git instalado.${NC}"; restart_script "$@"; } || { echo -e "${RED} Error al instalar Git.${NC}"; exit 1; }
        else
            echo -e "${RED} Git es necesario. Instálalo manualmente y reejecuta.${NC}"
            exit 1
        fi
    else
        echo -e "${RED} Git is not installed.${NC}"
        read -p "󰏩 Install Git automatically? (y/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" =~ ^[yY]$ ]]; then
            echo -e "${CYAN} Installing Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            [ $? -eq 0 ] && { echo -e "${GREEN} Git installed.${NC}"; restart_script "$@"; } || { echo -e "${RED} Error installing Git.${NC}"; exit 1; }
        else
            echo -e "${RED} Git is required. Please install it manually and rerun.${NC}"
            exit 1
        fi
    fi
fi

if ! command -v fc-list &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} fc-list no está instalado. Instala fontconfig (ej.: 'sudo apt install fontconfig') e inténtalo.${NC}"
    else
        echo -e "${RED} fc-list is not installed. Please install fontconfig and try again.${NC}"
    fi
    exit 1
fi

NERD_FONT_INSTALLED=$(fc-list | grep -i "Nerd")
if [ -z "$NERD_FONT_INSTALLED" ]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} No se detectaron Nerd Fonts instaladas.${NC}"
        read -p "󰏩 ¿Instalar Nerd Fonts? (s/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" =~ ^[sS]$ ]]; then
            echo -e "${CYAN} Instalando Nerd Fonts...${NC}"
        else
            echo -e "${RED} Continuando sin Nerd Fonts. La visualización puede sufrir.${NC}"
        fi
    else
        echo -e "${RED} No Nerd Fonts detected.${NC}"
        read -p "󰏩 Install Nerd Fonts? (y/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" =~ ^[yY]$ ]]; then
            echo -e "${CYAN} Installing Nerd Fonts...${NC}"
        else
            echo -e "${RED} Continuing without Nerd Fonts. Display might be affected.${NC}"
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
                echo -e "${GREEN} Nerd Fonts instaladas. Reinicia la terminal.${NC}"
            else
                echo -e "${GREEN} Nerd Fonts installed. Please restart your terminal.${NC}"
            fi
        else
            if [[ "$LANGUAGE" == "es" ]]; then
                echo -e "${RED} Error clonando Nerd Fonts.${NC}"
            else
                echo -e "${RED} Error cloning Nerd Fonts repository.${NC}"
            fi
            exit 1
        fi
    fi
fi

# --- Instalación del repositorio y configuración local ---
if [ ! -d "$LOCAL_REPO" ]; then
    echo -e "${YELLOW} No se encontró $LOCAL_REPO. Clonando repositorio...${NC}"
    # Ajusta la URL de tu repositorio
    git clone https://github.com/tu_usuario/tu_repositorio.git "$LOCAL_REPO" || { echo -e "${RED} Error clonando el repositorio.${NC}"; exit 1; }
fi

find "$LOCAL_REPO" -type f -name "*.sh" -exec chmod +x {} \;

if [ -d "$LOCAL_REPO/.config/meow-colorscripts" ]; then
    rm -rf "$CONFIG_DIR"
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$CONFIG_DIR"
    echo -e "${GREEN} Carpeta de configuración movida a $CONFIG_DIR.${NC}"
else
    echo -e "${YELLOW} No se encontró carpeta de configuración en el repositorio.${NC}"
fi

# --- Instalación de comandos en ~/.local/bin (estilo fastfetch) ---
mkdir -p "$HOME/.local/bin"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# Instalar meow-colorscripts (basado en show-meows.sh)
if [ -f "$CONFIG_DIR/show-meows.sh" ]; then
    install -Dm755 "$CONFIG_DIR/show-meows.sh" "$HOME/.local/bin/meow-colorscripts"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${GREEN} Comando meow-colorscripts instalado correctamente.${NC}"
    else
        echo -e "${GREEN} meow-colorscripts installed successfully.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Error: show-meows.sh no se encontró en $CONFIG_DIR.${NC}"
    else
        echo -e "${RED} Error: show-meows.sh not found in $CONFIG_DIR.${NC}"
    fi
fi

# Instalar meow-update
if [ -f "$LOCAL_REPO/update.sh" ]; then
    install -Dm755 "$LOCAL_REPO/update.sh" "$HOME/.local/bin/meow-update"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${GREEN} Comando meow-update instalado correctamente.${NC}"
    else
        echo -e "${GREEN} meow-update installed successfully.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Error: update.sh no se encontró en el repositorio local.${NC}"
    else
        echo -e "${RED} Error: update.sh not found in the local repository.${NC}"
    fi
fi

# Instalar meow-colorscripts-setup (para ejecutar setup.sh)
if [ -f "$SETUP_SCRIPT" ]; then
    install -Dm755 "$SETUP_SCRIPT" "$HOME/.local/bin/meow-colorscripts-setup"
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${GREEN} Comando meow-colorscripts-setup instalado correctamente.${NC}"
    else
        echo -e "${GREEN} meow-colorscripts-setup installed successfully.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Error: setup.sh no se encontró en el repositorio local.${NC}"
    else
        echo -e "${RED} Error: setup.sh not found in the repository.${NC}"
    fi
fi

# --- Frases de carga felinas ---
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
    echo -ne "${CYAN}$RANDOM_MSG"
    for j in {1..3}; do 
        echo -ne "."
        sleep 0.5
    done
    echo -e " ${GREEN}${NC}"
done

# --- Preguntar si se desea abrir la configuración ahora ---
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${CYAN} ¿Deseas abrir la configuración ahora?${NC}"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[sS]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
else
    echo -e "\n ${CYAN} Do you want to open the configuration now?${NC}"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " OPEN_CONF
    if [[ "$OPEN_CONF" =~ ^[yY]$ ]]; then
        bash "$SETUP_SCRIPT"
    fi
fi

echo -e "\n Instalación completada."
