# LLM-Bench

## Benchmarking with Optimum-Benchmark (recommended)

Follow [instructions](./optimum/README.md)

## Benchmarking with TGI (deprecated)

Follow [instructions](./tgi/README.md)



Todo: 

- [ ] Récupérer & filtrer la liste des modèles à tester ([drive](https://docs.google.com/spreadsheets/d/155WvuIdCkWMifurQ3qEi5jzKP87wx9smkA7mObwe3rg/edit?usp=sharing)) [Louise]
- [x] Créer le S3 [Sam]
- [ ] Script bench unitaire pour un modèle [Mohamed + Louise en backup]
    1. paramètre le nom du modèle (credentials du S3)
    2. lance la commande optimum (override)
        -> commande override pour choisir le modèle et le dossier output
        -> quantization (config dans le yaml)
    3. upload sur le S3
- [ ] Script lance le script unitaire à la suite (liste de modèles)
- [ ] Notebook
    - [ ] télécharger, nomalisation, ...


Phases
1. Test du process avec des petit modèles (<10B) dense et moe, mais pas de quantization
    -> Objectif: savoir si on a besoin de faire une adaption de la méthodo d'estimation de la conso élec pour les modèles moe 
2. (Si besoin d'adaptation méthodod) Benchmarking complet des modèles dense et moe entre ~1B et ~70B+ en quantization 4bits
    -> Objectif: modifier la modélisation de la conso énergétique des modèles dans la méthodo en combinant LLM-Perf et nos résultats
3. Tests avec vLLM 


Commande avec override:

```shell
optimum-benchmark --config-dir examples/ --config-name pytorch backend.model=gpt2 backend.device=cuda
```


## S3 Bucket

Configure profile:

`~/.aws/config`

```
[profile gia-scw]
region = fr-par
output = json
services = scw-fr-par
s3 =
  max_concurrent_requests = 100
  max_queue_size = 1000
  multipart_threshold = 50 MB
  # Edit the multipart_chunksize value according to the file sizes that you
  # want to upload. The present configuration allows to upload files up to
  # 10 GB (1000 requests * 10 MB). For example, setting it to 5 GB allows you
  # to upload files up to 5 TB.
  multipart_chunksize = 10 MB

[services scw-fr-par]
s3 =
  endpoint_url = https://s3.fr-par.scw.cloud
```

`~/.aws/credentials`

```
[gia-scw]
aws_access_key_id = <access_key_id>
aws_secret_access_key = <secret_access_key>
```

Synchronize directory:

```shell
aws --profile gia-scw s3 sync <path_to_runs_dir> s3://gia-llmbench-s3/runs/
```
