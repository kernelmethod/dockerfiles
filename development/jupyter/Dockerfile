# wshand/minimal-notebook
#
# Minimal Jupyter notebook container. Borrwed in part from
# 
#
#   https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook

###
### Base notebook build
###
ARG BASE_CONTAINER=debian:buster-slim
FROM $BASE_CONTAINER

USER root

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade -yq \
    && apt-get install -yq \
        python3 \
        python3-pip \
    && apt-get install -yq --no-install-recommends \
        build-essential \
        lmodern \
        python3-dev \
        pandoc \
        texlive-fonts-extra \
        texlive-fonts-recommended \
        texlive-generic-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        texlive-xetex \
#
# Cleanup
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --upgrade --no-cache-dir pip \
    && python3 -m pip install --no-cache-dir jupyter jupyterlab

#
# Create a non-root user to run Jupyter notebook
ENV NB_USER="julia"
RUN useradd \
        --create-home \
        --shell /bin/bash \
        ${NB_USER}

USER ${NB_USER}
WORKDIR /home/${NB_USER}
RUN mkdir ./work \
#
# Configure Jupyter to run on IP 0.0.0.0 when launched
    && jupyter notebook --generate-config \
    && sed -i \
        "s/\#c\.NotebookApp\.ip.*$/c\.NotebookApp\.ip = \"0.0.0.0\"/g" \
        .jupyter/jupyter_notebook_config.py

EXPOSE 8888
ENV TERM="xterm-256color"

CMD [ "jupyter", "notebook" ]
