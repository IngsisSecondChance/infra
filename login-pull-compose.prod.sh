#!/bin/bash

# Definir el nombre de usuario del dueño del repositorio
GHCR_USER="ingsis-second-chance"

# Obtener el PAT de una variable de entorno del sistema
GHCR_PAT=$(cat .env | grep GHCR_PAT | cut -d '=' -f2)

# Autenticarse en GHCR
echo "Autenticando en ghcr.io..."
echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USER" --password-stdin

# Verifica si la autenticación fue exitosa
if [ $? -ne 0 ]; then
  echo "Error: No se pudo autenticar en GitHub Container Registry."
  exit 1
fi

# Hacer docker-compose pull para obtener las últimas imágenes
echo "Haciendo docker-compose pull..."
docker compose -f docker-compose.prod.yml pull snippet-manager print-script-manager permissions-manager ui-service

# Verifica si docker-compose pull fue exitoso
if [ $? -ne 0 ]; then
  echo "Error: No se pudieron traer las imágenes."
  exit 1
fi

# Ejecutar docker-compose up para iniciar los servicios
echo "Iniciando servicios con docker-compose up..."
docker compose -f docker-compose.prod.yml up -d