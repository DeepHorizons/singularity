FROM ubuntu:18.04

ENV SINGULARITY_VERSION "2.6.0"
ENV NUM_CPU 16
ENV CI_PROJECT_DIR /opt
ENV LANG en_US.utf8

# Install everything nessesary to build singularity
RUN apt-get update && apt-get install -y \
    # From singularity
    python \
    dh-autoreconf \
    build-essential \
    squashfs-tools \
    uuid-dev \
    libssl-dev \
    libarchive-dev \
    make \
    wget \
    tar \
    git

RUN wget --no-check-certificate https://github.com/singularityware/singularity/releases/download/$SINGULARITY_VERSION/singularity-$SINGULARITY_VERSION.tar.gz && \
    tar xvf singularity-$SINGULARITY_VERSION.tar.gz && \
    cd singularity-$SINGULARITY_VERSION && \
    ./configure --prefix=$CI_PROJECT_DIR/singularity && \
    make -j$NUM_CPU && \
    make install && \
    rm -rf singularity-$SINGULARITY_VERSION*

ENV PATH="${PATH}:/opt/singularity/bin"


