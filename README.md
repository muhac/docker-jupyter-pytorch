# JupyterLab Docker Image with PyTorch GPU

JupyterLab for AI in Docker! `conda` installed. By default, the JupyterLab server runs on an Anaconda environment with PyTorch and some other commonly used libraries installed.

This docker configuration is Ubuntu 22.04 LTS, CUDA version 12.1, cuDNN 8. You may change the base system and the CUDA version listed here: [nvidia/cuda | DockerHub](https://hub.docker.com/r/nvidia/cuda/tags?page=1).

CUDA Docker environment is supported by [Ubuntu nvidia cuda toolkit](https://packages.ubuntu.com/jammy/amd64/nvidia-cuda-toolkit). Instruction: [CUDA and cuDNN Install | Pop!_OS](https://support.system76.com/articles/cuda/). It should work on Windows as well, with WSL.

## Available Tags

Docker image tag name: `env001`.

This image is built for the development environment of the
[U of T ECE1786](https://www.eecg.utoronto.ca/~jayar/ece1786.2024/)
course (Fall 2024) Assignment 1.

## Install & Usage

The image automatically runs a JupyterLab server on port `80`. Working directory in the container: `/root/projects`.

```bash
PROJECT_DIR=./
SERVER_PORT=80
docker run --detach \
    --name jupyter --restart unless-stopped \
    --ipc=host --runtime=nvidia --gpus all \
    -p $SERVER_PORT:80 \
    -v $PROJECT_DIR:/root/projects \
    muhac/conda-cuda:env001
```

You can use [this notebook](JupyterLabConfig/notebooks/PyTorchGPU.ipynb) to check your PyTorch GPU environment.

It is also possible to create your own conda environment and change `/root/.bashrc` to use a different one when starting JupyterLab. If you want to do this, make sure you keep all related files synced in the host system to prevent loss after pulling a new image.
