FROM ubuntu:16.04

# install gcc9 (from )

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install build-essential software-properties-common -y && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update -y && \
    apt-get install gcc-9 g++-9 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    update-alternatives --config gcc

# install other build dependencies git and wget and zlib 

RUN apt-get install git wget libz-dev libbz2-dev liblzma-dev -y

# clone repo

RUN cd /tmp && \
    git clone --recursive https://github.com/MBoemo/DNAscent.git

# compile hdf5

RUN cd /tmp/DNAscent &&\
    wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.14/src/hdf5-1.8.14.tar.gz; \
    tar -xzf hdf5-1.8.14.tar.gz || exit 255; \
    cd hdf5-1.8.14 && \
            ./configure --enable-threadsafe && \
            make && make install;

# download tensorflow

RUN cd /tmp/DNAscent &&\
    mkdir tensorflow; \
    cd tensorflow; \
    wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-linux-x86_64-1.15.0.tar.gz; \
    tar -xzf libtensorflow-gpu-linux-x86_64-1.15.0.tar.gz || exit 255; 

# compile DNAscent

RUN cd /tmp/DNAscent &&\
    make

# Add to path

ENV PATH="${PATH}:/tmp/DNAscent/bin"