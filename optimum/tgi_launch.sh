#!/bin/bash

# Launch benchmark
optimum-benchmark --config-dir examples --config-name tgi_llama name=tgi_tinyllama


# Find the container ID for the specified image
container_id=$(docker ps -a | grep ghcr.io/huggingface/text-generation-inference | awk '{print $1}')

# Check if a container was found
if [ -n "$container_id" ]; then
    # Stop the container
    docker stop $container_id
    echo "Container $container_id has been stopped."
fi