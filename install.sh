#!/bin/bash

# Install script for Kroki Docker Compose setup
# This script pulls Docker images and starts all services

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Detect docker compose command (v2 or v1)
if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
elif docker-compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "Error: Neither 'docker compose' nor 'docker-compose' found" >&2
    exit 1
fi

# Source .env file if it exists
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

echo "Installing Kroki Docker Compose setup..."
echo "Pulling Docker images..."

# Pull all images
if ! $DOCKER_COMPOSE -f docker-compose-with-nginx.yml pull; then
    echo "Error: Failed to pull Docker images" >&2
    exit 1
fi

echo "Starting services in detached mode..."

# Start services in detached mode
if ! $DOCKER_COMPOSE -f docker-compose-with-nginx.yml up -d; then
    echo "Error: Failed to start services" >&2
    exit 1
fi

echo "Installation complete!"
echo "Services are running in the background."
echo "Use './start.sh' to start, './stop.sh' to stop, './restart.sh' to restart, or './monitor.sh' to monitor."

