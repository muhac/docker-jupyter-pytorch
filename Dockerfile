# Use CUDA 12.1
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04
SHELL ["/bin/bash", "-c"]
ENV SHELL=/bin/bash
ENV DEBIAN_FRONTEND=noninteractive

# Export paths for CUDA and cuDNN
RUN echo $'\n\
    export CUDA_HOME=/usr/local/cuda \n\
    export PATH=/usr/local/cuda/bin:$PATH \n\
    export CPATH=/usr/local/cuda/include:/usr/include:$CPATH \n\
    export LIBRARY_PATH=/usr/local/cuda/lib64:$LIBRARY_PATH \n\
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH \n\
' >> /root/.bashrc

# Install basic packages
RUN apt-get update --fix-missing && \
    apt-get install bzip2 ca-certificates curl wget git vim nano tree -y && \
    apt-get install pandoc texlive-xetex texlive-fonts-recommended texlive-plain-generic -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh && \
    bash ~/anaconda.sh -b -p $HOME/anaconda && rm ~/anaconda.sh && \
    eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && conda init && \
    conda config --set channel_priority strict

# Install Anaconda and JupyterLab
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && \
    conda create -n torch python=3.8 anaconda ipywidgets -y && \
    echo "conda activate torch" >> /root/.bashrc && \
    conda clean -a && pip cache purge

# Setup JupyterLab plugins
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && conda activate torch && \
    echo "jupyter lab" > /root/run_jupyter.sh && \
    conda install -c pytorch -c nvidia -c conda-forge \
        jupyterlab-lsp python-lsp-server r-languageserver \
        jupyterlab_code_formatter jupyterlab-spellchecker jupyterlab-git \
        jupyter-resource-usage jupyterlab_execute_time jupyterlab-latex && \
    pip install lckr_jupyterlab_variableinspector jupyterlab_wakatime && \
    conda clean -a && pip cache purge

COPY JupyterLabConfig/jupyter_lab_config.py /root/.jupyter/jupyter_lab_config.py
COPY JupyterLabConfig/extensions/ /root/.jupyter/lab/user-settings/\@jupyterlab/
COPY JupyterLabConfig/notebooks/ /root/projects/demo_notebooks/
COPY JupyterLabConfig/channels.condarc /root/.condarc

# Install PyTorch and AI libs
RUN eval "$('/root/anaconda/bin/conda' 'shell.bash' 'hook')" && conda activate torch && \
    conda install -c pytorch -c nvidia -c conda-forge \
        pytorch==1.11.0 torchvision==0.12.0 torchaudio==0.11.0 cudatoolkit=11.3 \
        torchtext==0.12.0 spacy && \
    conda clean -a && pip cache purge

# Run JupyterLab on start
WORKDIR /root/projects
CMD ["/bin/bash", "-i", "/root/run_jupyter.sh"]
EXPOSE 80

HEALTHCHECK CMD  curl -f -s http://localhost/lab || exit 1
