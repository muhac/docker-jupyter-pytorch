# Anaconda Docker Image with CUDA and cuDNN

CUDA Docker environment is supported by [Ubuntu nvidia cuda toolkit](https://packages.ubuntu.com/jammy/amd64/nvidia-cuda-toolkit). Instruction: [CUDA and cuDNN Install | Pop!_OS](https://support.system76.com/articles/cuda/).

This docker file is used for Ubuntu 20.04 LTS, CUDA version 11.6. You may change the base system and the CUDA version listed here: [nvidia/cuda | Docker Hub](https://hub.docker.com/r/nvidia/cuda/tags?page=1).

## Available Tags

More Docker tags are in other Git branches.

- `11.6`: CUDA 11.6, Miniconda installed
- `11.6-anaconda`: CUDA 11.6, Anaconda 23.07 installed
- `11.6-torch_1.13.1`: CUDA 11.6, Anaconda with PyTorch 1.13.1

## Install & Usage

The images with Anaconda automatically run a jupyter notebook on port `8888`. Working directory: `/work`

```bash
docker run --detach \
    --name conda-cuda \
    --restart unless-stopped \
    --runtime=nvidia \
    --gpus all \
    -p 8888:8888 \
    -v project:/work/project \
    muhac/conda-cuda:torch
```

You can use [this notebook](notebook/PyTorchGPU.ipynb) to check your PyTorch GPU environment.
