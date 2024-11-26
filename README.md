# LLM-Bench

## Benchmarking with Optimum-Benchmark (recommended)

Follow [instructions](./optimum/README.md)

## Benchmarking with TGI (deprecated)

Follow [instructions](./tgi/README.md)



Todo: 

- [ ] Récupérer & filtrer la liste des modèles à tester ([drive](https://docs.google.com/spreadsheets/d/155WvuIdCkWMifurQ3qEi5jzKP87wx9smkA7mObwe3rg/edit?usp=sharing)) [Louise]
- [ ] Créer le S3 [Sam]
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
