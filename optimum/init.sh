# Install optimum-benchmark
python3 -m venv .venv
source .venv/bin/activate
pip install huggingface_hub==0.23.2
pip install codecarbon==2.7.2
pip install git+https://github.com/huggingface/optimum-benchmark.git
