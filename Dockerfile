# Use CUDA 12.1
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 as base
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# Install basic packages
RUN apt-get update --fix-missing && \
    apt-get install bzip2 ca-certificates curl wget git vim -y && \
    apt-get install pandoc texlive-xetex texlive-fonts-recommended texlive-plain-generic -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p $HOME/anaconda && rm ~/anaconda.sh && \
    eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && conda init

# Install Pytorch latest on Anaconda
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && \
    conda create -n torch python=3.11 anaconda -y && conda clean -a && conda activate torch && \
    conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia && conda clean -a

# Export paths for CUDA and cuDNN
RUN echo $'\n\
    export CUDA_HOME=/usr/local/cuda \n\
    export PATH=/usr/local/cuda/bin:$PATH \n\
    export CPATH=/usr/local/cuda/include:/usr/include:$CPATH \n\
    export LIBRARY_PATH=/usr/local/cuda/lib64:$LIBRARY_PATH \n\
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH \n\
' >> /root/.bashrc

# Setup Jupyter Notebook Themes
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && \
    conda activate torch && \
    conda install -c conda-forge jupyterlab_code_formatter jupyterlab_execute_time && \
    conda install -c conda-forge jupyterlab-lsp python-lsp-server r-languageserver && \
    pip install jupyterlab-spellchecker lckr_jupyterlab_variableinspector && \
    conda install ipywidgets=7.7.5 transformers && \
    conda clean -a && pip cache purge

# Setup Jupyter Notebook
RUN echo "conda activate torch" >> /root/.bashrc && \
    mkdir -p /work/project && \
    echo "cd /work && jupyter-notebook --ip='*' --port=8888 --allow-root" > /root/init.sh
COPY notebook/config.json /root/.jupyter/jupyter_notebook_config.json
COPY notebook/PyTorchGPU.ipynb /work/PyTorchGPU.ipynb

# Set default command on start
CMD ["/bin/bash", "-i", "/root/init.sh"]
