FROM debian:10
LABEL Maintainer: Tim Molteno "tim@elec.ac.nz"
ARG DEBIAN_FRONTEND=noninteractive


# debian setup
RUN apt-get update && \
    apt-get install -y build-essential make swig \
    curl \
    python-matplotlib \
    python-numpy \
    python-scipy \
    mplayer \
    imagemagick \
    expect cvs

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# RUN rm -rf /var/lib/apt/lists/*

WORKDIR /build 


RUN groupadd -g 1234 spamgroup && \
    useradd -m -u 1234 -g spamgroup spamuser


USER spamuser:spamgroup


WORKDIR /build/spam 

COPY files/spam_20240308.tgz spam.tgz
COPY files/spam_etc_20181208.tgz spam_etc.tgz
COPY files/AIPS_31DEC13.tgz .
COPY files/parseltongue-2.3e.tgz .
COPY files/obit_20160115.tgz .

# Install SPAM support files

RUN tar xzf spam_etc.tgz

RUN ls -l
#export SPAM_PATH=/net/dedemsvaart/data1/spam_devel
#export SPAM_HOST=DEDEMSVAART
#export PYTHON=/usr/bin/python2.7
#export PATH=${SPAM_PATH}/bin:${PATH}


# Do  this instead of running setup.sh
ENV PYTHON=/usr/bin/python2.7
ENV SPAM_PATH /build/spam
ENV SPAM_HOST DEDEMSVAART
ENV PATH="$SPAM_PATH/bin:$PATH"

# Install AIPS_31DEC13
RUN tar xzf AIPS_31DEC13.tgz
WORKDIR /build/spam/AIPS

WORKDIR /build/spam/lib
USER root
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libfftw3f.so.3 /usr/local/lib/
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libgslcblas.so.0 /usr/local/lib/
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libquadmath.so.0 /usr/local/lib/
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libgfortran.so.3 /usr/local/lib/
# RUN echo $LD_LIBRARY_PATH
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib:$SPAM_PATH/lib"
RUN ldconfig


USER spamuser:spamgroup
WORKDIR /build/spam/AIPS

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib:$SPAM_PATH/lib"

# RUN ls -l
# 
# WORKDIR /build/spam


ADD files/.AIPSRC .AIPSRC
RUN cat .AIPSRC

COPY files/install_aips.sh .
COPY files/install.exp .

# CMD autoexpect -p ./install_aips.sh; cat script.exp
RUN ./install.exp

# Configuring AIPS using the expect script which provides inputs for the
# prompts from AIPS commands. 
COPY files/services /root/services

COPY files/configure_aips.sh .
# CMD autoexpect -p ./configure_aips.sh; cat script.exp
COPY files/script.exp .
RUN ./script.exp


## GOING UP TO HERE

USER root


    
    
    
    
    
    
    
    
    

## Install Orbit Core

WORKDIR /build/spam
RUN ls -l
RUN tar zxf obit_20160115.tgz


## Install parseltongue

ENV PYTHONPATH="$SPAM_PATH/Obit/python:$PYTHONPATH"

RUN apt-get autoremove
RUN apt-get install -y -f build-essential

COPY test.py .
RUN python2.7 test.py

RUN tar xzf parseltongue-2.3e.tgz
WORKDIR /build/spam/parseltongue-2.3e
RUN ./configure --prefix=$SPAM_PATH/ParselTongue --with-obit=$SPAM_PATH/Obit
RUN make install

# Install SPAM

WORKDIR /build/spam
RUN ls -l
RUN tar xzf spam.tgz
WORKDIR /build/spam/python/spam

RUN make

WORKDIR /build/spam

RUN curl 'https://raw.githubusercontent.com/pypa/get-pip/20.3.4/get-pip.py' -o get-pip.py
RUN python get-pip.py
RUN pip install astropy

RUN . ./setup.sh
CMD cd /spam_store; /bin/sh -i
