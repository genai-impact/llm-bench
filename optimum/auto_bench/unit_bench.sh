#!/bin/bash

# Default values of the paramters
model=""
aws_access_key_id=""
aws_secret_access_key=""

# Get the values set by the user of the paramters
for arg in "$@"; do
  case $arg in
    --model=*)
      model="${arg#*=}" # Extract the value after '='
      shift # Remove processed argument
      ;;
    --aws_access_key_id=*)
      aws_access_key_id="${arg#*=}" # Extract the value after '='
      shift # Remove processed argument
      ;;
    --aws_secret_access_key=*)
      aws_secret_access_key="${arg#*=}" # Extract the value after '='
      shift # Remove processed argument
      ;;
    *)
      echo "Invalid argument: $arg"
      echo "Usage: $0 --model=<model_name> --aws_access_key_id=<aws_access_key_id> --aws_secret_access_key=<aws_secret_access_key>"
      exit 1 # Exit after invalid argument
      ;;
  esac
done

# If any required argument is missing, print an error and exit
if [ -z "$model" ] || [ -z "$aws_access_key_id" ] || [ -z "$aws_secret_access_key" ]; then
  echo "Error: Missing required arguments."
  echo "Usage: $0 --model=<model_name> --aws_access_key_id=<aws_access_key_id> --aws_secret_access_key=<aws_secret_access_key>"
  exit 1
fi

CURRENT_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$CURRENT_SCRIPT_DIR"

# If optimum-benchmark is not installed, install it
if [ ! -d "optimum-benchmark" ]; then
  python3 -m venv optimum-benchmark/venv
  source optimum-benchmark/venv/bin/activate
  pip install optimum-benchmark==0.4.0
  pip install huggingface_hub==0.23.2
  pip install codecarbon==2.7.2
else
  source optimum-benchmark/venv/bin/activate
fi

# Extract the content after the last "/" in the model name
if [[ "$model" == *"/"* ]]; then
    model_name="${model##*/}"
else
    model_name="$model"
fi

# Run the bench
CONFIG_DIR="$CURRENT_SCRIPT_DIR/../configs/"
optimum-benchmark --config-dir "$CONFIG_DIR" --config-name pytorch backend.model="$model" name="$model_name"

# AWS config file
aws_config_file="$HOME/.aws/config"

# Ensure the config file exists or create it otherwise
if [[ ! -f "$aws_config_file" ]]; then
  cp "$CURRENT_SCRIPT_DIR/aws_config" "$HOME/.aws/config"
fi

# AWS credentials file
aws_credentials_file="$HOME/.aws/credentials"

# Ensure the credentials file exists or create it otherwise
if [[ ! -f "$aws_credentials_file" ]]; then
  mkdir -p "$(dirname "$aws_credentials_file")"
  touch "$aws_credentials_file"
fi

# Update the credentials file
profile=gia-scw
if grep -q "^\[$profile\]" "$aws_credentials_file"; then
  # Update existing profile
  sed -i "/^\[$profile\]/,/^$/ s/aws_access_key_id = .*/aws_access_key_id = $aws_access_key_id/" "$aws_credentials_file"
  sed -i "/^\[$profile\]/,/^$/ s/aws_secret_access_key = .*/aws_secret_access_key = $aws_secret_access_key/" "$aws_credentials_file"
else
  # Append new profile
  echo -e "\n[$profile]" >> "$aws_credentials_file"
  echo "aws_access_key_id = $aws_access_key_id" >> "$aws_credentials_file"
  echo "aws_secret_access_key = $aws_secret_access_key" >> "$aws_credentials_file"
fi

RUNS_DIR="$CURRENT_SCRIPT_DIR/runs/$model_name"
echo "aws --profile gia-scw s3 sync $RUNS_DIR s3://gia-llmbench-s3/runs/"

cp -r "$RUNS_DIR" "$HOME/Desktop"