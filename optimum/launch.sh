#!/bin/bash

# Default value for the model parameter
model=""

# Get the value set by the user for the model parameter
for arg in "$@"; do
  case $arg in
    --model=*)
      model="${arg#*=}" # Extract the value after '='
      shift # Remove processed argument
      ;;
    *)
      echo "Invalid argument: $arg"
      echo "Usage: $0 --model=<model_name>"
      exit 1 # Exit after invalid argument
      ;;
  esac
done

# If the model argument is missing, print an error and exit
if [ -z "$model" ]; then
  echo "Error: Missing required argument."
  echo "Usage: $0 --model=<model_name>"
  exit 1
fi

CURRENT_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$CURRENT_SCRIPT_DIR"

# Activate virtualenv
source .venv/bin/activate

# Extract the content after the last "/" in the model name
if [[ "$model" == *"/"* ]]; then
    model_name="${model##*/}"
else
    model_name="$model"
fi

# Run the bench
CONFIG_DIR="$CURRENT_SCRIPT_DIR/../configs/"
optimum-benchmark --config-dir "$CONFIG_DIR" --config-name pytorch backend.model="$model" name="$model_name"

# Synchronize runs directory
RUNS_DIR="$CURRENT_SCRIPT_DIR/runs/"
echo "aws --profile gia-scw s3 sync $RUNS_DIR s3://gia-llmbench-s3/runs/"
