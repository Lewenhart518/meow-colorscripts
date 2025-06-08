# ────────────────────────────────────────────────────────────── 
# Preguntar por el estilo de meow-colorscripts
if [[ "$LANGUAGE" == "es" ]]; then
    echo -e " ${CYAN}Elige tu estilo de meow-colorscripts:${NC}"
    echo -e "  1) ${WHITE}normal${NC}"
    echo -e "  2) ${WHITE}nocolor${NC}"
    echo -e "  3) ${CYAN}temas (nord, catpuccin, everforest)${NC}"
    echo -e "  4) ${GREEN}ascii${NC}"
    echo -e "  5) ${GREEN}ascii-color${NC}"
    read -p "󰏩 Selecciona una opción [1-5]: " STYLE_OPTION
else
    echo -e " ${CYAN}Choose your meow-colorscripts style:${NC}"
    echo -e "  1) ${WHITE}normal${NC}"
    echo -e "  2) ${WHITE}nocolor${NC}"
    echo -e "  3) ${CYAN}themes (nord, catpuccin, everforest)${NC}"
    echo -e "  4) ${GREEN}ascii${NC}"
    echo -e "  5) ${GREEN}ascii-color${NC}"
    read -p "󰏩 Select an option [1-5]: " STYLE_OPTION
fi
# ────────────────────────────────────────────────────────────── 

case "$STYLE_OPTION" in
    1)
        MEOW_THEME="normal"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
            echo -e "  1) ${GREEN}Small${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Large${NC}"
            read -p "󰏩 Select an option [1-3]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="small" ;;
            2) MEOW_SIZE="normal" ;;
            3) MEOW_SIZE="large" ;;
            *) MEOW_SIZE="normal" ;;
        esac
        ;;
    2)
        MEOW_THEME="nocolor"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
            echo -e "  1) ${GREEN}Small${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Large${NC}"
            read -p "󰏩 Select an option [1-3]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="small" ;;
            2) MEOW_SIZE="normal" ;;
            3) MEOW_SIZE="large" ;;
            *) MEOW_SIZE="normal" ;;
        esac
        ;;
    3)
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tema deseas usar?${NC}"
            echo -e "  1) ${CYAN}nord${NC}"
            echo -e "  2) ${CYAN}catpuccin${NC}"
            echo -e "  3) ${CYAN}everforest${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " THEME_OPTION
        else
            echo -e "\n${CYAN}Which theme do you want to use?${NC}"
            echo -e "  1) ${CYAN}nord${NC}"
            echo -e "  2) ${CYAN}catpuccin${NC}"
            echo -e "  3) ${CYAN}everforest${NC}"
            read -p "󰏩 Select an option [1-3]: " THEME_OPTION
        fi
        case "$THEME_OPTION" in
            1) MEOW_THEME="nord" ;;
            2) MEOW_THEME="catpuccin" ;;
            3) MEOW_THEME="everforest" ;;
            *) MEOW_THEME="nord" ;;
        esac
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
            echo -e "  1) ${GREEN}Small${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Large${NC}"
            read -p "󰏩 Select an option [1-3]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="small" ;;
            2) MEOW_SIZE="normal" ;;
            3) MEOW_SIZE="large" ;;
            *) MEOW_SIZE="normal" ;;
        esac
        ;;
    4)
        MEOW_THEME="ascii"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "  2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}Which type of ASCII do you prefer?${NC}"
            echo -e "  1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "  2) ${RED}Blocks${NC}"
            read -p "󰏩 Select an option [1-2]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        ;;
    5)
        MEOW_THEME="ascii-color"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tipo de ASCII prefieres?${NC}"
            echo -e "  1) ${YELLOW}Símbolos de teclado${NC}"
            echo -e "  2) ${RED}Bloques${NC}"
            read -p "󰏩 Selecciona una opción [1-2]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}Which type of ASCII do you prefer?${NC}"
            echo -e "  1) ${YELLOW}Keyboard symbols${NC}"
            echo -e "  2) ${RED}Blocks${NC}"
            read -p "󰏩 Select an option [1-2]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="keyboard-symbols" ;;
            2) MEOW_SIZE="block" ;;
            *) MEOW_SIZE="keyboard-symbols" ;;
        esac
        ;;
    *)
        MEOW_THEME="normal"
        if [[ "$LANGUAGE" == "es" ]]; then
            echo -e "\n${CYAN}¿Qué tamaño prefieres?${NC}"
            echo -e "  1) ${GREEN}Pequeño${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Grande${NC}"
            read -p "󰏩 Selecciona una opción [1-3]: " SIZE_OPTION
        else
            echo -e "\n${CYAN}What size do you prefer?${NC}"
            echo -e "  1) ${GREEN}Small${NC}"
            echo -e "  2) ${WHITE}Normal${NC}"
            echo -e "  3) ${RED}Large${NC}"
            read -p "󰏩 Select an option [1-3]: " SIZE_OPTION
        fi
        case "$SIZE_OPTION" in
            1) MEOW_SIZE="small" ;;
            2) MEOW_SIZE="normal" ;;
            3) MEOW_SIZE="large" ;;
            *) MEOW_SIZE="normal" ;;
        esac
        ;;
esac
