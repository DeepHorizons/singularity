FROM ubuntu:18.04 as build

ENV LANG=en_US.utf8

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt bionic main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    tar \
    ca-certificates \
    cryptsetup-bin

# Install go
ENV VERSION=1.13.1 OS=linux ARCH=amd64
RUN cd /tmp && \
    wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz

# XXX For some reason these need to be on different lines
ENV PATH=/usr/local/go/bin:$PATH
ENV SINGULARITY_VERSION="3.4.1"

# Install singularity
RUN cd /tmp && \
    wget https://github.com/sylabs/singularity/releases/download/v$SINGULARITY_VERSION/singularity-$SINGULARITY_VERSION.tar.gz && \
    tar -zxf singularity-$SINGULARITY_VERSION.tar.gz && \
    cd singularity && \
    ./mconfig -p /usr/local/singularity && \
    make -C ./builddir && \
    make -C ./builddir install && \
    rm ../singularity-$SINGULARITY_VERSION.tar.gz

ENV PATH="$PATH:/usr/local/singularity/bin"

FROM ubuntu:18.04
COPY --from=build /usr/local/singularity /usr/local/singularity
RUN apt-get update && apt-get install -y \
    ca-certificates \
    squashfs-tools \
    uidmap
ENV PATH="/usr/local/singularity/bin:$PATH"
RUN rm /etc/subuid /etc/subgid

