# Install optimum-benchmark
python3 -m venv .venv
source .venv/bin/activate
pip install huggingface_hub
pip install codecarbon
pip install git+https://github.com/huggingface/optimum-benchmark.git

# For AWQ
#pip install autoawq[kernels]

# For GPTQ
#pip install optimum
#pip install -U "numpy<2" 
#pip install torch==2.2.1 --index-url https://download.pytorch.org/whl/cu121
#pip install auto-gptq --no-build-isolation