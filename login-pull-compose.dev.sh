#!/bin/bash

# Definir el nombre de usuario del dueño del repositorio
GHCR_USER="ingsis-second-chance"

# Obtener el PAT de una variable de entorno del sistema
GHCR_PAT=$(cat .env | grep GHCR_PAT | cut -d '=' -f2)

# Verificar si la variable de entorno GHCR_PAT está definida
if [ -z "$GHCR_PAT" ]; then
  echo "Error: La variable de entorno GHCR_PAT no está definida."
  exit 1
fi

# Autenticarse en GHCR
echo "Autenticando en ghcr.io..."
echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USER" --password-stdin

# Verifica si la autenticación fue exitosa
if [ $? -ne 0 ]; then
  echo "Error: No se pudo autenticar en GitHub Container Registry."
  exit 1
fi

# Hacer docker-compose pull para obtener las últimas imágenes
echo "Haciendo docker-compose pull... dev"
docker compose -f docker-compose.dev.yml pull snippet-manager print-script-manager permissions-manager ui-service

# Verifica si docker-compose pull fue exitoso
if [ $? -ne 0 ]; then
  echo "Error: No se pudieron traer las imágenes."
  exit 1
fi

# Ejecutar docker-compose up para iniciar los servicios
echo "Iniciando servicios con docker-compose up..."
docker compose -f docker-compose.dev.yml up -d

