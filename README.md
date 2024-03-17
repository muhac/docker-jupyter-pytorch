# Anaconda Docker Image with CUDA and cuDNN

CUDA Docker environment is supported by [Ubuntu nvidia cuda toolkit](https://packages.ubuntu.com/jammy/amd64/nvidia-cuda-toolkit). Instruction: [CUDA and cuDNN Install | Pop!_OS](https://support.system76.com/articles/cuda/).

This docker file is used for Ubuntu 22.04 LTS, CUDA version 12.1. You may change the base system and the CUDA version listed here: [nvidia/cuda | Docker Hub](https://hub.docker.com/r/nvidia/cuda/tags?page=1).

## Available Tags

More Docker tags are in other Git branches.

- `12.1`: CUDA 12.1, Miniconda installed
- `12.1-anaconda`: CUDA 12.1, Anaconda 23.07 installed
- `12.1-torch_2.2.1`: CUDA 12.1, Anaconda with PyTorch 2.2.1

## Install & Usage

The images with Anaconda automatically run a jupyter notebook on port `8888`. Working directory: `/work/`.

```bash
docker run --detach \
    --name conda-cuda \
    --restart unless-stopped \
    --runtime=nvidia \
    --gpus all \
    -p 8888:8888 \
    -v project:/work \
    muhac/conda-cuda:12.1-torch_2.2.1
```

You can use [this notebook](notebook/PyTorchGPU.ipynb) to check your PyTorch GPU environment.
