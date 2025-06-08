#!/bin/bash

CONFIG_FILE="$HOME/.config/meow-colorscripts/meow.conf"
LANG_FILE="$HOME/.config/meow-colorscripts/lang"
NAMES_FILE="$HOME/.config/meow-colorscripts/names.txt"

# Nord Aurora Colors
GREEN='\033[38;2;94;129;172m'
RED='\033[38;2;191;97;106m'
YELLOW='\033[38;2;235;203;139m'
CYAN='\033[38;2;143;188;187m'
WHITE='\033[38;2;216;222;233m'
NC='\033[0m'

# 🐾 Selección de idioma
echo -e "${CYAN} Selecciona tu idioma:${NC}"
echo -e "s) sí"
echo -e "n) no"
read -p "Elige una opción [s/n]: " LANG_OPTION

LANGUAGE="en"
if [[ "$LANG_OPTION" == "s" ]]; then
    LANGUAGE="es"
fi
echo "$LANGUAGE" > "$LANG_FILE"

# 🐾 Frases felinas de carga únicas 🐾
if [[ "$LANGUAGE" == "es" ]]; then
    LOADING_MSGS=("󰀅 Los gatos se estiran" " Acomodando almohadillas" " Afinando maullidos" "★ Ronroneo en progreso" "󰀅 Explorando el código")
else
    LOADING_MSGS=("󰀅 The cats are stretching" " Adjusting paw pads" " Fine-tuning meows" "★ Purring in progress" "󰀅 Exploring the code")
fi

# 🐾 Animaciones de carga con mensajes únicos
LOADING_USED=()
for i in {1..3}; do 
    while true; do
        LOADING_MSG=${LOADING_MSGS[$RANDOM % ${#LOADING_MSGS[@]}]}
        if [[ ! " ${LOADING_USED[*]} " =~ " $LOADING_MSG " ]]; then
            LOADING_USED+=("$LOADING_MSG")
            break
        fi
    done
    echo -ne "${CYAN}$LOADING_MSG"
    for j in {1..3}; do echo -ne "."; sleep 0.5; done
    echo -e "${GREEN}${NC}"
done

# 🐾 Preguntar por el estilo
echo -e "${CYAN}󰀅 Elige tu estilo de meow-colorscripts:${NC}"
echo -e "1) ${WHITE}Normal${NC}"
echo -e "2) ${WHITE}Sin color${NC}"
echo -e "3) ${CYAN}Tema: Nord, Catpuccin, Everforest${NC}"
echo -e "4) ${GREEN}ASCII: Símbolos o Bloques${NC}"
read -p "Selecciona una opción [1-4]: " STYLE_OPTION

case "$STYLE_OPTION" in
    1) MEOW_THEME="normal" ;;
    2) MEOW_THEME="nocolor" ;;
    3) 
        echo -e "\n${CYAN}󰀅 ¿Qué tema quieres usar?${NC}"
        echo -e "1) ${GREEN}Nord${NC}"
        echo -e "2) ${CYAN}Catpuccin${NC}"
        echo -e "3) ${YELLOW}Everforest${NC}"
        read -p "Selecciona una opción [1-3]: " THEME_OPTION
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="normal" ;;
        esac
        ;;
    4) 
        echo -e "\n${CYAN}󰀅 ¿Qué tipo de ASCII prefieres?${NC}"
        echo -e "1) ${YELLOW}Símbolos de teclado${NC}"
        echo -e "2) ${RED}Bloques${NC}"
        read -p "Selecciona una opción [1-2]: " ASCII_TYPE_OPTION
        case "$ASCII_TYPE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        MEOW_THEME="ascii"
        ;;
    *) MEOW_THEME="normal" ;;
esac

# 🐾 Activar comandos de nombres
echo -e "\n${CYAN}󰀅 ¿Quieres activar 'meows-names' y 'meows-show [name]'?${NC}"
echo -e "s) sí"
echo -e "n) no"
read -p "Selecciona una opción [s/n]: " ENABLE_NAMES_OPTION

if [[ "$ENABLE_NAMES_OPTION" == "s" ]]; then
    ls "$HOME/.config/meow-colorscripts/colorscripts/$MEOW_THEME/$MEOW_SIZE" | grep ".txt" | sed 's/.txt//' > "$NAMES_FILE"
    echo -e "${GREEN} Archivo de nombres generado correctamente: ${WHITE}$NAMES_FILE${NC}"
fi

# 🐾 Guardar configuración en meow.conf
echo "MEOW_THEME=$MEOW_THEME" > "$CONFIG_FILE"
echo "MEOW_SIZE=$MEOW_SIZE" >> "$CONFIG_FILE"

echo -e "\n${GREEN} Configuración guardada exitosamente.${NC}"
echo -e "󰚝 Archivo de configuración: ${WHITE}$CONFIG_FILE${NC}"

# 🐾 Mostrar comandos activados si el usuario los seleccionó
if [[ -f "$NAMES_FILE" ]]; then
    echo -e "\n${CYAN}󰀅 Comandos activados:${NC}"
    echo -e "${WHITE}- meows-names${NC}"
    echo -e "${WHITE}- meows-show [name]${NC}"
fi

echo -e "\n${GREEN} Configuración completada. ¡Ansi-meow está listo!${NC}"
