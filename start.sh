#!/bin/bash

# Start script for Kroki Docker Compose setup
# This script starts all services in detached mode

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

echo "Starting Kroki services..."

# Check if services are already running
RUNNING_SERVICES=$($DOCKER_COMPOSE ps --services --filter "status=running" 2>/dev/null | grep -v '^$' || true)
if [ -n "$RUNNING_SERVICES" ]; then
    echo "Some services are already running:"
    echo "$RUNNING_SERVICES"
    echo "Use './restart.sh' to restart or './stop.sh' to stop first."
    exit 0
fi

# Start services in detached mode
if ! $DOCKER_COMPOSE up -d; then
    echo "Error: Failed to start services" >&2
    exit 1
fi

echo "Services started successfully!"
echo "Use './monitor.sh' to view logs and status."

