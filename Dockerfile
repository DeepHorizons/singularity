FROM ubuntu:18.04

ENV SINGULARITY_VERSION="3.1.0" LANG=en_US.utf8

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    wget \
    git \
    tar \
    squashfs-tools  # mksquashfs

# Install go
ENV VERSION=1.11 OS=linux ARCH=amd64
RUN cd /tmp && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz

# XXX For some reason these need to be on different lines
ENV HOME=/root
ENV GOPATH=$HOME/go
ENV PATH=/usr/local/go/bin:$PATH:$GOPATH/bin

# Install singularity
RUN mkdir -p $GOPATH/src/github.com/sylabs && \
    cd /tmp && \
    wget --no-check-certificate https://github.com/singularityware/singularity/releases/download/v$SINGULARITY_VERSION/singularity-$SINGULARITY_VERSION.tar.gz && \
    tar xf singularity-$SINGULARITY_VERSION.tar.gz -C $GOPATH/src/github.com/sylabs/ && \
    rm /tmp/singularity-$SINGULARITY_VERSION.tar.gz && \
    cd $GOPATH/src/github.com/sylabs/singularity && \
    go get -u github.com/golang/dep/cmd/dep && \
    ./mconfig -p /usr/local/singularity && \
    make -C ./builddir && \
    make -C ./builddir install

ENV PATH="$PATH:/usr/local/singularity/bin"


