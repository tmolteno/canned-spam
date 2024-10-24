FROM debian:10
LABEL Maintainer: Tim Molteno "tim@elec.ac.nz"
ARG DEBIAN_FRONTEND=noninteractive


# debian setup
RUN apt-get update 
RUN apt-get -y upgrade
RUN apt-get install -y build-essential make swig

RUN apt-get install -y \
    curl \
    python-matplotlib \
    python-numpy \
    python-scipy 

RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
RUN apt-get install -y mplayer imagemagick

# RUN rm -rf /var/lib/apt/lists/*

WORKDIR /build 


RUN groupadd -g 1234 spamgroup && \
    useradd -m -u 1234 -g spamgroup spamuser

RUN apt-get install -y expect cvs


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



ADD files/.AIPSRC .AIPSRC
RUN cat .AIPSRC

COPY files/install.exp .

RUN ./install.exp

USER root



# Configuring AIPS using the expect script which provides inputs for the
# prompts from AIPS commands. 
COPY files/services /root/services
COPY files/script.exp .

RUN ./script.exp
RUN chmod +x LOGIN.SH



    
    
    
    
    
    
    
    
    

## Install Orbit Core

WORKDIR /build/spam
RUN ls -l
RUN tar zxf obit_20160115.tgz


## Install parseltongue

ENV PYTHONPATH="$SPAM_PATH/Obit/python:$PYTHONPATH"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SPAM_PATH/lib"

RUN apt-get autoremove
RUN aptitude install -y -f build-essential

WORKDIR /build/spam/lib
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libfftw3f.so.3 .
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libgslcblas.so.0 .
ADD https://ftp.strw.leidenuniv.nl/intema/spam/lib/libquadmath.so.0 .
RUN ls -l

WORKDIR /build/spam
COPY test.py .
RUN python2.7 test.py

RUN tar xzf parseltongue-2.3e.tgz
WORKDIR /build/spam/parseltongue-2.3e
RUN ./configure --prefix=$SPAM_PATH/ParselTongue --with-obit=$SPAM_PATH/Obit
RUN make install

# Install SPAM

WORKDIR /build/spam
RUN ls -l
RUN tar xzf spam_2*.tgz
WORKDIR /build/spam/python/spam

RUN make
