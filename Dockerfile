FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update --fix-missing && \
    apt-get install bzip2 ca-certificates curl wget git vim nano tree -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Conda Environment
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p $HOME/anaconda && rm ~/anaconda.sh && \
    eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && conda init && \
    conda config --set channel_priority strict

# Install Anaconda and JupyterLab
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && \
    conda create -n lab python=3.11 -y && \
    echo "conda activate lab" >> /root/.bashrc && \
    conda clean -a && pip cache purge

# Install PyTorch and AI libs
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && conda activate lab && \
    conda install -c pytorch -c nvidia -c conda-forge --strict-channel-priority \
        pytorch torchvision torchaudio pytorch-cuda=12.4 \
        transformers datasets accelerate && \
    pip install openai sentencepiece huggingface_hub[cli] && \
    conda clean -a && pip cache purge

# Run JupyterLab on start
WORKDIR /root/projects
CMD ["/bin/bash", "-i", "echo 0"]
