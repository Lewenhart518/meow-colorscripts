#!/bin/bash

INSTALL_DIR="$HOME/.config"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"
LANG_FILE="$LOCAL_REPO/.config/meow-colorscripts/lang"

# ────────────────────────────────────────────────────────────── 
# Nerd Fonts Colors and Icons
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'
# Iconos usados:
#   -> Encabezado o título
# 󰏩 -> Indicador de entrada/prompt
# 󰚝 -> Indicador de movimiento/acción
#   -> Confirmación
#   -> Opción adicional o de pregunta
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Asegurar que la carpeta de configuración existe en el repositorio local
mkdir -p "$LOCAL_REPO/.config/meow-colorscripts"
touch "$LANG_FILE"
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Selección de idioma
echo -e " ${CYAN}Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
read -p "󰏩 Choose an option [1/2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi
echo "$LANGUAGE" > "$LANG_FILE"
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Asegurarse de que el directorio de destino exista en ~/.config/
mkdir -p "$HOME/.config/meow-colorscripts"

# Mover el archivo lang a la ubicación final
mv "$LOCAL_REPO/.config/meow-colorscripts/lang" "$HOME/.config/meow-colorscripts/lang"
if [[ -f "$HOME/.config/meow-colorscripts/lang" ]]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${GREEN}Archivo de idioma movido correctamente.${NC}"
    else
        echo -e " ${GREEN}Language file moved successfully.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${RED}Error: No se pudo mover el archivo de idioma.${NC}"
    else
        echo -e " ${RED}Error: Could not move language file.${NC}"
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Copiar show-meows.sh al directorio de configuración
if [[ -f "$LOCAL_REPO/show-meows.sh" ]]; then
    cp "$LOCAL_REPO/show-meows.sh" "$HOME/.config/meow-colorscripts/"
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Mensajes de carga dinámicos
LOADING_USED=()
LOADING_MSGS_ES=(" Los gatos se estiran" "󰄛 Acomodando almohadillas" "󰏩 Afinando maullidos" "󱏿 Ronroneo en progreso" "󰏩 Explorando el código")
LOADING_MSGS_EN=(" The cats are stretching" "󰄛 Adjusting paw pads" "󰏩 Fine-tuning meows" "󱏿 Purring in progress" "󰏩 Exploring the code")

for i in {1..3}; do 
    while true; do
        LOADING_MSG=${LOADING_MSGS_EN[$RANDOM % ${#LOADING_MSGS_EN[@]}]}
        if [[ "$LANGUAGE" == "es" ]]; then
            LOADING_MSG=${LOADING_MSGS_ES[$RANDOM % ${#LOADING_MSGS_ES[@]}]}
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
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Mover configuración
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${GREEN}󰚝 Moviendo configuración de meow-colorscripts...${NC}"
else
    echo -e "${GREEN}󰚝 Moving meow-colorscripts configuration...${NC}"
fi
sleep 1
if [[ -d "$LOCAL_REPO/.config/meow-colorscripts" ]]; then
    mv "$LOCAL_REPO/.config/meow-colorscripts" "$INSTALL_DIR/" &> /dev/null
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}󰀅 Error: No se encontró la carpeta de configuración en el repositorio.${NC}"
    else
        echo -e "${RED}󰀅 Error: Configuration folder not found in repository.${NC}"
    fi
fi
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${GREEN} Configuración movida correctamente.${NC}"
else
    echo -e "${GREEN} Configuration moved successfully.${NC}"
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Detectar shell y agregar alias
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${CYAN}󰄛 Detectando shell y agregando alias...${NC}"
else
    echo -e "${CYAN}󰄛 Detecting shell and adding alias...${NC}"
fi
sleep 1
USER_SHELL=$(basename "$SHELL")
ALIAS_CMD="alias ansi-meow='bash ~/.config/meow-colorscripts/show-meows.sh'"
if [ -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" ]; then
    case "$USER_SHELL" in
        "bash") echo "$ALIAS_CMD" >> "$HOME/.bashrc" ;;
        "zsh") echo "$ALIAS_CMD" >> "$HOME/.zshrc" ;;
        "fish")
            echo -e "function ansi-meow" >> "$HOME/.config/fish/config.fish"
            echo -e "    bash ~/.config/meow-colorscripts/show-meows.sh" >> "$HOME/.config/fish/config.fish"
            echo -e "end" >> "$HOME/.config/fish/config.fish"
            ;;
    esac
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${GREEN} Alias agregado correctamente.${NC}"
        echo -e "${YELLOW} Debes reiniciar la terminal para que funcione el alias.${NC}"
    else
        echo -e "${GREEN} Alias added successfully.${NC}"
        echo -e "${YELLOW} You must restart the terminal for the alias to work.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}󰀅 Error: No se encontró show-meows.sh.${NC}"
    else
        echo -e "${RED}󰀅 Error: show-meows.sh not found.${NC}"
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Preguntar si se desea abrir la configuración ahora
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n${CYAN} ¿Deseas abrir la configuración ahora?${NC}"
    echo -e "  1) Sí"
    echo -e "  2) No"
    read -p "󰏩 Selecciona una opción [1-2]: " OPEN_CONF
else
    echo -e "\n${CYAN} Do you want to open the configuration now?${NC}"
    echo -e "  1) Yes"
    echo -e "  2) No"
    read -p "󰏩 Select an option [1-2]: " OPEN_CONF
fi

if [[ "$OPEN_CONF" == "1" ]]; then
    if [ -f "$SETUP_SCRIPT" ]; then
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "${CYAN}󰏩 Abriendo configuración...${NC}"
        else
            echo -e "${CYAN}󰏩 Opening configuration...${NC}"
        fi
        bash "$SETUP_SCRIPT"
    else
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "${RED}󰀅 Error: No se encontró setup.sh.${NC}"
        else
            echo -e "${RED}󰀅 Error: setup.sh not found.${NC}"
        fi
    fi
fi
# ────────────────────────────────────────────────────────────── 
