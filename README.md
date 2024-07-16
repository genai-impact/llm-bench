# llm-bench

## Launch TGI 

```shell
hf_token=
model=TinyLlama/TinyLlama-1.1B-Chat-v1.0
```

For GPU:

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

For CPU (testing):

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
