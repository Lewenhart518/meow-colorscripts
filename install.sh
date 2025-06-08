#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts y comandos sin alias
# (Sin los comandos de nombres: meow-show y meows-names)
# ========================================================

# ========================================================
# Función para reiniciar el script (después de instalar una dependencia)
restart_script() {
    echo " Reiniciando el instalador..."
    exec "$0" "$@"
}

# ------------------------------------------------------------
# Variables principales
INSTALL_DIR="$HOME/.config"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# Colores para mensajes en la terminal
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# ========================================================
# Selección de idioma (mensajes en español o inglés)
# ========================================================
echo -e " ${CYAN}Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
read -p "󰏩 Choose an option [1/2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi

# Crear carpeta para la configuración temporal en el repositorio local y guardar el idioma
mkdir -p "$LOCAL_REPO/.config/meow-colorscripts"
LANG_FILE="$LOCAL_REPO/.config/meow-colorscripts/lang"
echo "$LANGUAGE" > "$LANG_FILE"

# ========================================================
# DETECCIÓN DE DEPENDENCIAS: Git
# ========================================================
if ! command -v git &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${RED}Git no está instalado.${NC}"
        read -p "󰏩 ¿Deseas instalar Git automáticamente? (s/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" == "s" || "$INSTALL_GIT" == "S" ]]; then
            echo -e " ${CYAN}Instalando Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            if [ $? -eq 0 ]; then
                echo -e " ${GREEN}Git instalado correctamente.${NC}"
                restart_script "$@"
            else
                echo -e " ${RED}Error al instalar Git. Instálalo manualmente e inténtalo de nuevo.${NC}"
                exit 1
            fi
        else
            echo -e " ${RED}Git es necesario para continuar. Instálalo manualmente e inténtalo nuevamente.${NC}"
            exit 1
        fi
    else
        echo -e " ${RED}Git is not installed.${NC}"
        read -p "󰏩 Do you want to automatically install Git? (y/n): " INSTALL_GIT
        if [[ "$INSTALL_GIT" == "y" || "$INSTALL_GIT" == "Y" ]]; then
            echo -e " ${CYAN}Installing Git...${NC}"
            sudo apt-get update && sudo apt-get install -y git
            if [ $? -eq 0 ]; then
                echo -e " ${GREEN}Git installed successfully.${NC}"
                restart_script "$@"
            else
                echo -e " ${RED}Error installing Git. Please install it manually and re-run the installer.${NC}"
                exit 1
            fi
        else
            echo -e " ${RED}Git is required to continue. Please install it manually and run the installer again.${NC}"
            exit 1
        fi
    fi
fi

# ========================================================
# DETECCIÓN DE DEPENDENCIAS: fc-list (fontconfig)
# ========================================================
if ! command -v fc-list &> /dev/null; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${RED}fc-list no está instalado. Instala fontconfig (ej.: 'sudo apt install fontconfig') e inténtalo nuevamente.${NC}"
    else
        echo -e " ${RED}fc-list is not installed. Please install fontconfig (e.g., 'sudo apt install fontconfig') and try again.${NC}"
    fi
    exit 1
fi

# ========================================================
# DETECCIÓN E INSTALACIÓN DE NERD FONTS
# ========================================================
NERD_FONT_INSTALLED=$(fc-list | grep -i "Nerd")
if [ -z "$NERD_FONT_INSTALLED" ]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${RED}No se detectaron Nerd Fonts instaladas.${NC}"
        read -p "󰏩 ¿Deseas instalar Nerd Fonts? (s/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" == "s" || "$INSTALL_NERD" == "S" ]]; then
            echo -e " ${CYAN}Instalando Nerd Fonts...${NC}"
        else
            echo -e " ${RED}Continuando sin instalar Nerd Fonts. Es posible que la visualización no sea la correcta.${NC}"
        fi
    else
        echo -e " ${RED}No Nerd Fonts were detected.${NC}"
        read -p "󰏩 Do you want to install Nerd Fonts? (y/n): " INSTALL_NERD
        if [[ "$INSTALL_NERD" == "y" || "$INSTALL_NERD" == "Y" ]]; then
            echo -e " ${CYAN}Installing Nerd Fonts...${NC}"
        else
            echo -e " ${RED}Continuing without installing Nerd Fonts. Display might not be correct.${NC}"
        fi
    fi

    if [[ "$INSTALL_NERD" == "s" || "$INSTALL_NERD" == "S" || "$INSTALL_NERD" == "y" || "$INSTALL_NERD" == "Y" ]]; then
        git clone https://github.com/ryanoasis/nerd-fonts.git /tmp/nerd-fonts
        if [ $? -eq 0 ]; then
            cd /tmp/nerd-fonts || exit
            ./install.sh
            cd - > /dev/null
            rm -rf /tmp/nerd-fonts
            if [[ "$LANGUAGE" == "es" ]]; then
                echo -e " ${GREEN}Nerd Fonts instaladas. Es recomendable reiniciar la terminal.${NC}"
            else
                echo -e " ${GREEN}Nerd Fonts installed. It's recommended to restart your terminal.${NC}"
            fi
        else
            if [[ "$LANGUAGE" == "es" ]]; then
                echo -e " ${RED}Error al clonar el repositorio de Nerd Fonts.${NC}"
            else
                echo -e " ${RED}Error cloning the Nerd Fonts repository.${NC}"
            fi
            exit 1
        fi
    fi
fi

# ========================================================
# Continuación de la instalación de meow-colorscripts
# ========================================================
# Mover la carpeta de configuración del repositorio local a ~/.config/
mkdir -p "$INSTALL_DIR"
mv "$LOCAL_REPO/.config/meow-colorscripts" "$INSTALL_DIR/" &> /dev/null

if [[ -d "$INSTALL_DIR/meow-colorscripts" ]]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${GREEN}Archivo de configuración movido correctamente.${NC}"
    else
        echo -e " ${GREEN}Configuration folder moved successfully.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${RED}Error: No se pudo mover la carpeta de configuración.${NC}"
    else
        echo -e " ${RED}Error: Could not move configuration folder.${NC}"
    fi
fi

# Verificar que show-meows.sh esté en la carpeta de configuración destino
if [[ ! -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" && -f "$LOCAL_REPO/show-meows.sh" ]]; then
    cp "$LOCAL_REPO/show-meows.sh" "$INSTALL_DIR/meow-colorscripts/"
fi

if [[ -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" ]]; then
    echo -e " ${GREEN}show-meows.sh copiado correctamente.${NC}"
else
    echo -e " ${RED}Error: No se encontró show-meows.sh en el destino.${NC}"
fi

# ========================================================
# Mensajes de carga dinámicos (frases felinas)
# ========================================================
LOADING_USED=()
LOADING_MSGS_ES=(" Los gatos se estiran" "󰚝 Acomodando almohadillas" "󰏩 Afinando maullidos" "󱏿 Ronroneo en progreso" "󰏩 Explorando el código")
LOADING_MSGS_EN=(" The cats are stretching" "󰚝 Adjusting paw pads" "󰏩 Fine-tuning meows" "󱏿 Purring in progress" "󰏩 Exploring the code")

for i in {1..3}; do 
    while true; do
        if [[ "$LANGUAGE" == "es" ]]; then
            LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
        else
            LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
        fi
        if [[ ! " ${LOADING_USED[*]} " =~ " $LOADING_MSG " ]]; then
            LOADING_USED+=("$LOADING_MSG")
            break
        fi
    done
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do 
        echo -ne "."
        sleep 0.5
    done
    echo -e "${GREEN}${NC}"
done

# ========================================================
# Verificación final de la carpeta de configuración
# ========================================================
if [[ -d "$INSTALL_DIR/meow-colorscripts" ]]; then
    echo -e "${GREEN} Configuración movida correctamente.${NC}"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Error: No se encontró la carpeta de configuración en el destino.${NC}"
    else
        echo -e "${RED} Error: Configuration folder not found at destination.${NC}"
    fi
fi

# ========================================================
# Instalar comandos en ~/.local/bin (sin alias)
# ========================================================
mkdir -p "$HOME/.local/bin"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# ------------------------------------------------------------
# INSTALACIÓN DEL COMANDO meow-colorscripts (usa show-meows.sh)
if [ -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" ]; then
    cp "$INSTALL_DIR/meow-colorscripts/show-meows.sh" "$HOME/.local/bin/meow-colorscripts"
    chmod +x "$HOME/.local/bin/meow-colorscripts"
    echo -e " ${GREEN}Comando meow-colorscripts instalado correctamente.${NC}"
else
    echo -e " ${RED}Error: show-meows.sh no encontrado para instalar meow-colorscripts.${NC}"
fi

# ------------------------------------------------------------
# INSTALACIÓN DEL COMANDO meow-update (update.sh)
if [ -f "$LOCAL_REPO/update.sh" ]; then
    chmod +x "$LOCAL_REPO/update.sh"
    cp "$LOCAL_REPO/update.sh" "$HOME/.local/bin/meow-update"
    chmod +x "$HOME/.local/bin/meow-update"
    echo -e " ${GREEN}Comando meow-update instalado correctamente.${NC}"
else
    echo -e " ${RED}Error: update.sh no encontrado en el repositorio local.${NC}"
fi

# ------------------------------------------------------------
# INSTALACIÓN DEL COMANDO meow-colorscripts-setup (para ejecutar setup.sh)
if [ -f "$SETUP_SCRIPT" ]; then
    cp "$SETUP_SCRIPT" "$HOME/.local/bin/meow-colorscripts-setup"
    chmod +x "$HOME/.local/bin/meow-colorscripts-setup"
    echo -e " ${GREEN}Comando meow-colorscripts-setup instalado correctamente.${NC}"
else
    echo -e " ${RED}Error: setup.sh no encontrado para instalar meow-colorscripts-setup.${NC}"
fi

# ========================================================
# Preguntar si se desea abrir la configuración ahora
# ========================================================
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${CYAN} ¿Deseas abrir la configuración ahora?${NC}"
    echo -e "  s) Sí"
    echo -e "  n) No"
    read -p "󰏩 Selecciona una opción [s/n]: " OPEN_CONF
else
    echo -e "\n ${CYAN} Do you want to open the configuration now?${NC}"
    echo -e "  y) Yes"
    echo -e "  n) No"
    read -p "󰏩 Select an option [y/n]: " OPEN_CONF
fi

if [[ "$LANGUAGE" == "es" ]]; then
    if [[ "$OPEN_CONF" == "s" || "$OPEN_CONF" == "S" ]]; then
        if [ -f "$SETUP_SCRIPT" ]; then
            echo -e "${CYAN}󰏩 Abriendo configuración...${NC}"
            bash "$SETUP_SCRIPT"
        else
            echo -e "${RED} Error: No se encontró setup.sh.${NC}"
        fi
    fi
else
    if [[ "$OPEN_CONF" == "y" || "$OPEN_CONF" == "Y" ]]; then
        if [ -f "$SETUP_SCRIPT" ]; then
            echo -e "${CYAN}󰏩 Opening configuration...${NC}"
            bash "$SETUP_SCRIPT"
        else
            echo -e "${RED} Error: setup.sh not found.${NC}"
        fi
    fi
fi

# ========================================================
# Guardar la configuración en meow.conf (en ~/.config/meow-colorscripts)
# ========================================================
echo "MEOW_THEME=$MEOW_THEME" > "$INSTALL_DIR/meow-colorscripts/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$INSTALL_DIR/meow-colorscripts/meow.conf"

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${GREEN}Configuración guardada exitosamente.${NC}"
    echo -e "Archivo de configuración: ${WHITE}$INSTALL_DIR/meow-colorscripts/meow.conf${NC}"
else
    echo -e "\n ${GREEN}Configuration saved successfully.${NC}"
    echo -e "Configuration file: ${WHITE}$INSTALL_DIR/meow-colorscripts/meow.conf${NC}"
fi

