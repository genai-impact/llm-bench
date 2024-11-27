#!/bin/bash

# Default values of the paramters
model=""
aws_access_key_id=""
aws_secret_access_key=""

# Parse arguments
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

# AWS credentials file
aws_credentials_file="$HOME/.aws/credentials"

# Ensure the credentials file exists
if [[ ! -f "$aws_credentials_file" ]]; then
  echo "AWS credentials file not found at $aws_credentials_file. Creating it..."
  mkdir -p "$(dirname "$aws_credentials_file")"
  touch "$aws_credentials_file"
fi

profile=gia-scw
# Update the credentials file
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

# Echo the command to run
echo "optimum-benchmark --config-dir examples/ --config-name pytorch backend.model=$model backend.device=cuda"
echo "aws --profile gia-scw s3 sync <path_to_runs_dir> s3://gia-llmbench-s3/runs/"