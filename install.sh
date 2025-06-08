#!/bin/bash

# ========================================================
# Instalación de meow-colorscripts y comandos sin alias
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

# ------------------------------------------------------------
# (Iconos:  para idioma, 󰏩 para prompt,  para confirmación,  para error,
#   para actualización/ajuste,  para configuración,  para caja abierta)
#
# Crear la carpeta de configuración en el repositorio local
mkdir -p "$LOCAL_REPO/.config/meow-colorscripts"
# Definir el archivo de idioma en el repositorio local
LANG_FILE="$LOCAL_REPO/.config/meow-colorscripts/lang"
touch "$LANG_FILE"

# ------------------------------------------------------------
# Selección de idioma
echo -e " ${CYAN}Select your language:${NC}"
echo -e "  1) Español"
echo -e "  2) English"
read -p "󰏩 Choose an option [1/2]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "1" ]]; then
    LANGUAGE="es"
fi
echo "$LANGUAGE" > "$LANG_FILE"

# ------------------------------------------------------------
# Mover la carpeta de configuración del repositorio local a ~/.config/
# Esto mueve: ~/meow-colorscripts/.config/meow-colorscripts --> ~/.config/meow-colorscripts
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

# ------------------------------------------------------------
# Garantizar que show-meows.sh esté en la carpeta de configuración destino (~/.config/meow-colorscripts)
if [[ ! -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" && -f "$LOCAL_REPO/show-meows.sh" ]]; then
    cp "$LOCAL_REPO/show-meows.sh" "$INSTALL_DIR/meow-colorscripts/"
fi

if [[ -f "$INSTALL_DIR/meow-colorscripts/show-meows.sh" ]]; then
    echo -e " ${GREEN}show-meows.sh copiado correctamente.${NC}"
else
    echo -e " ${RED}Error: No se encontró show-meows.sh en el destino.${NC}"
fi

# ------------------------------------------------------------
# Mensajes de carga dinámicos (para amenizar la espera)
LOADING_USED=()
LOADING_MSGS_ES=(" Los gatos se estiran" "󰚝 Acomodando almohadillas" "󰏩 Afinando maullidos" "󱏿 Ronroneo en progreso" "󰏩 Explorando el código")
LOADING_MSGS_EN=(" The cats are stretching" "󰚝 Adjusting paw pads" "󰏩 Fine-tuning meows" "󱏿 Purring in progress" "󰏩 Exploring the code")

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

# ------------------------------------------------------------
# Verificación final de la carpeta de configuración en ~/.config/
if [[ -d "$INSTALL_DIR/meow-colorscripts" ]]; then
    echo -e "${GREEN} Configuración movida correctamente.${NC}"
else
    if [[ "$LANGUAGE" == "es" ]]; then
        echo -e "${RED} Error: No se encontró la carpeta de configuración en el destino.${NC}"
    else
        echo -e "${RED} Error: Configuration folder not found at destination.${NC}"
    fi
fi

# ------------------------------------------------------------
# Instalar comandos en ~/.local/bin (sin usar alias)
mkdir -p "$HOME/.local/bin"
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

# ------------------------------------------------------------
# INSTALACIÓN DEL COMANDO meow-colorscripts
# Se copia show-meows.sh (desde ~/.config/meow-colorscripts) y se renombra a meow-colorscripts
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
# CREACIÓN DEL COMANDO meow-show (wrapper)
# Se usará como: meow-show [nombre]
cat << 'EOF' > "$HOME/.local/bin/meow-show"
#!/bin/bash
# Wrapper que pasa argumentos al comando meow-colorscripts.
meow-colorscripts "$@"
EOF
chmod +x "$HOME/.local/bin/meow-show"
echo -e " ${GREEN}Comando meow-show instalado correctamente.${NC}"

# ------------------------------------------------------------
# CREACIÓN DEL COMANDO meows-names
# Muestra el contenido del archivo names.txt ubicado en ~/.config/meow-colorscripts/
cat << 'EOF' > "$HOME/.local/bin/meows-names"
#!/bin/bash
cat "$HOME/.config/meow-colorscripts/names.txt"
EOF
chmod +x "$HOME/.local/bin/meows-names"
echo -e " ${GREEN}Comando meows-names instalado correctamente.${NC}"

# ------------------------------------------------------------
# INSTALACIÓN DEL COMANDO meow-colorscripts-setup (wrapper para setup.sh)
# Este comando permite abrir la configuración para generar names.txt y personalizar
if [ -f "$SETUP_SCRIPT" ]; then
    cp "$SETUP_SCRIPT" "$HOME/.local/bin/meow-colorscripts-setup"
    chmod +x "$HOME/.local/bin/meow-colorscripts-setup"
    echo -e " ${GREEN}Comando meow-colorscripts-setup instalado correctamente.${NC}"
else
    echo -e " ${RED}Error: setup.sh no encontrado para instalar meow-colorscripts-setup.${NC}"
fi

# ------------------------------------------------------------
# Preguntar si se desea abrir la configuración ahora (opcional)
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

# ------------------------------------------------------------
# Guardar la configuración en meow.conf (dentro de ~/.config/meow-colorscripts)
echo "MEOW_THEME=$MEOW_THEME" > "$INSTALL_DIR/meow-colorscripts/meow.conf"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$INSTALL_DIR/meow-colorscripts/meow.conf"

if [[ "$LANGUAGE" == "es" ]]; then
    echo -e "\n ${GREEN}Configuración guardada exitosamente.${NC}"
    echo -e "Archivo de configuración: ${WHITE}$INSTALL_DIR/meow-colorscripts/meow.conf${NC}"
else
    echo -e "\n ${GREEN}Configuration saved successfully.${NC}"
    echo -e "Configuration file: ${WHITE}$INSTALL_DIR/meow-colorscripts/meow.conf${NC}"
fi

