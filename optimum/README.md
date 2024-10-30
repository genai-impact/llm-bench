# Benchmarking with Optimum-Benchmark

## Pre-requites

Enable Docker as a non-root user (mandatory for Lambda Labs instances).

```shell
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```


## Installation

[Install optimum-benchmark](https://github.com/huggingface/optimum-benchmark?tab=readme-ov-file#installation-)

Set up `HF_TOKEN` environement variable.

```shell
export HF_TOKEN=...
```

## Usage

### Benchmarking with PyTorch backend

```shell
optimum-benchmark --config-dir configs --config-name pytorch
```

### Benchmarking with TGI backend

```shell
optimum-benchmark --config-dir configs --config-name tgi
```

Then manually stop TGI.
