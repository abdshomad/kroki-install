#!/bin/bash

# Stop script for Kroki Docker Compose setup
# This script stops all services

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

echo "Stopping Kroki services..."

# Stop services
if ! $DOCKER_COMPOSE stop; then
    echo "Error: Failed to stop services" >&2
    exit 1
fi

echo "Services stopped successfully!"

