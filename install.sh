#!/bin/bash
# ========================================================
# Instalación de meow-colorscripts y comandos sin alias
# ========================================================

# ========================================================
# Función: reiniciar el script (para continuar después de instalar una dependencia)
# ========================================================
restart_script() {
    echo " Reiniciando el instalador..."
    exec "$0" "$@"
}

# ========================================================
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
# Selección de idioma (se ejecuta primero para usar mensajes en español o inglés)
# ========================================================
echo -e " ${CYAN}Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
read -p "󰏩 Choose an option [1/2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi

# Guardar el idioma en un archivo temporal de la configuración
mkdir -p "$LOCAL_REPO/.config/meow-colorscripts"
LANG_FILE="$LOCAL_REPO/.config/meow-colorscripts/lang"
echo "$LANGUAGE" > "$LANG_FILE"

# ========================================================
# DETECCIÓN DE DEPENDENCIAS: Ejemplo con git
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
                echo -e " ${RED}Error al instalar Git. Por favor, instálalo manualmente y vuelve a ejecutar el instalador.${NC}"
                exit 1
            fi
        else
            echo -e " ${RED}Git es necesario para continuar. Instálalo manualmente e intenta de nuevo.${NC}"
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
# DETECCIÓN DE DEPENDENCIAS ADICIONALES: Ejemplo fc-list para fontconfig
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
# DETECCIÓN E INSTALACIÓN DE NERD FONTS (los mensajes se muestran en el idioma seleccionado)
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
        if ! command -v git &> /dev/null; then
            if [[ "$LANGUAGE" == "es" ]]; then
                echo -e " ${RED}Git no está instalado. Instálalo y ejecuta nuevamente el script.${NC}"
            else
                echo -e " ${RED}Git is not installed. Please install Git and rerun the script.${NC}"
            fi
            exit 1
        fi
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

# (La continuación del script sigue con la instalación de comandos, etc.)
# … [Resto del script de instalación de meow-colorscripts sigue igual]
