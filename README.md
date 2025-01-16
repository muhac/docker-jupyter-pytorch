# JupyterLab Docker Image with PyTorch GPU

JupyterLab in Docker! `conda` installed. This docker image runs on Ubuntu 24.04 LTS, with Python 3.13.1.

## Available Tags

Docker image tag name: `env-2501b`.

Full list are available on [muhac/jupyter-pytorch | DockerHub](https://hub.docker.com/r/muhac/jupyter-pytorch).

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
    muhac/jupyter-pytorch:env-2501a
```

It is also possible to create your own conda environment and change `/root/.bashrc` to use a different one when starting JupyterLab. If you want to do this, make sure you keep all related files synced in the host system to prevent loss after pulling a new image.
