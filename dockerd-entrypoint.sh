#!/bin/bash

# Start Docker daemon in background
dockerd &

# Wait for Docker to become ready
until docker info 2>/dev/null; do
    echo "Waiting for Docker to start..."
    sleep 1
done

echo "Docker is running."

# Start Jupyter Lab
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=''
