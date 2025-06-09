#!/bin/bash
# meow-fact: Muestra un dato curioso aleatorio en el idioma de configuración

CONFIG_DIR="$HOME/.config/meow-colorscripts"
LANGUAGE="en"
# Si existe el archivo de idioma, lo cargamos
if [ -f "$CONFIG_DIR/lang" ]; then
  LANGUAGE=$(cat "$CONFIG_DIR/lang")
fi

# Establecemos el directorio de datos curiosos según el idioma
FACT_DIR="$CONFIG_DIR/curious-facts/$LANGUAGE"

if [ ! -d "$FACT_DIR" ]; then
  echo "Directorio de datos curiosos no encontrado para el idioma '$LANGUAGE'."
  exit 1
fi

# Buscar archivos .txt en el directorio y elegir uno al azar
FACT_FILE=$(find "$FACT_DIR" -type f -name "*.txt" | shuf -n 1)

if [ -n "$FACT_FILE" ]; then
  echo -e "\n$(cat "$FACT_FILE")"
else
  echo -e "\nNo se encontraron datos curiosos."
fi
