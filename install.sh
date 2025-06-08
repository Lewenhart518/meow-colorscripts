#!/bin/bash

# Variables principales
INSTALL_DIR="$HOME/.config"
LOCAL_REPO="$HOME/meow-colorscripts"
SETUP_SCRIPT="$LOCAL_REPO/setup.sh"

# ────────────────────────────────────────────────────────────── 
# Nerd Fonts Colors and Icons
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'
# Iconos usados:
#   -> Título o encabezado
# 󰏩 -> Prompt o entrada de usuario
# 󰚝 -> Acción de movimiento
#   -> Confirmación
#   -> Pregunta o instrucción adicional
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Crear la carpeta de configuración dentro del repositorio local
mkdir -p "$LOCAL_REPO/.config/meow-colorscripts"
# Definir el archivo de idioma en el repositorio local (donde se almacena la elección)
LANG_FILE="$LOCAL_REPO/.config/meow-colorscripts/lang"
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
# Mover la carpeta completa de configuración del repositorio local a ~/.config/
# Es decir, mover ~/meow-colorscripts/.config/meow-colorscripts/ a ~/.config/
mkdir -p "$INSTALL_DIR"  # Asegurarse de que ~/.config exista
mv "$LOCAL_REPO/.config/meow-colorscripts" "$INSTALL_DIR/" &> /dev/null

if [[ -d "$INSTALL_DIR/meow-colorscripts" ]]; then
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${GREEN}Archivo de configuración movido correctamente.${NC}"
    else
        echo -e " ${GREEN}Configuration folder moved successfully.${NC}"
    fi
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e " ${RED}Error: No se pudo mover la carpeta de configuración.${NC}"
    else
        echo -e " ${RED}Error: Could not move configuration folder.${NC}"
    fi
fi
# ────────────────────────────────────────────────────────────── 

# ────────────────────────────────────────────────────────────── 
# Asegurar que el archivo show-meows.sh esté en el directorio de configuración
# Se espera que este archivo se encuentre en la raíz del repositorio LOCAL_REPO;
# si no está en ~/.config/meow-colorscripts/, se copia
if [[ ! -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" && -f "$LOCAL_REPO/show-meows.sh" ]]; then
    cp "$LOCAL_REPO/show-meows.sh" "$INSTALL_DIR/meow-colorscripts/"
fi

if [[ -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" ]]; then
    echo -e " ${GREEN}show-meows.sh copiado correctamente.${NC}"
else
    echo -e " ${RED}Error: No se encontró show-meows.sh en el destino.${NC}"
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
# Mover configuración (la carpeta ya movida se encuentra en ~/.config/)
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "${GREEN}󰚝 Moviendo configuración de meow-colorscripts...${NC}"
else
    echo -e "${GREEN}󰚝 Moving meow-colorscripts configuration...${NC}"
fi
sleep 1
# (La carpeta ya se movió previamente, pero se puede realizar alguna verificación adicional)
if [[ -d "$INSTALL_DIR/meow-colorscripts" ]]; then
    echo -e "${GREEN} Configuración movida correctamente.${NC}"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED}󰀅 Error: No se encontró la carpeta de configuración en el destino.${NC}"
    else
        echo -e "${RED}󰀅 Error: Configuration folder not found at destination.${NC}"
    fi
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
