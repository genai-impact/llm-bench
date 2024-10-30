# Benchmarking with TGI

## Pre-requites

Enable Docker as a non-root user (mandatory for Lambda Labs instances).

```shell
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

## Installation

...

## Usage

### Launch TGI server

```shell
hf_token=...
model=TinyLlama/TinyLlama-1.1B-Chat-v1.0
```

#### With GPU support

```shell
docker run \
    --rm \
    --name tgi \
    --gpus all \
    --shm-size 64g \
    -e HF_TOKEN=hf_token \
    -p 8080:80 \
    -v ./server/models:/data \
    ghcr.io/huggingface/text-generation-inference:2.1.1 \
    --model-id $model
```

#### With CPU-only support

```shell
docker run \
    --rm \
    --name tgi \
    --shm-size 64g \
    -e HF_TOKEN=hf_token \
    -p 8080:80 \
    -v ./server/models:/data \
    ghcr.io/huggingface/text-generation-inference:2.1.1 \
    --model-id $model
```

### Launch client

...
