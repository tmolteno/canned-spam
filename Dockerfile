FROM debian:bullseye
LABEL Maintainer: Tim Molteno "tim@elec.ac.nz"
ARG DEBIAN_FRONTEND=noninteractive

RUN cat /etc/apt/sources.list 

RUN echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list

# debian setup
RUN apt-get update 
RUN apt-get install -y aptitude
RUN aptitude upgrade
RUN aptitude install -y gcc make swig

RUN aptitude install -y \
    curl \
    python-matplotlib \
    python-astropy \
    python-numpy \
    python-scipy 

RUN aptitude install -y mplayer imagemagick

# RUN rm -rf /var/lib/apt/lists/*

WORKDIR /build 
RUN mkdir spam
WORKDIR /build/spam 

ADD files/spam_20240308.tgz .
ADD files/spam_etc_20181208.tgz .
ADD files/AIPS_31DEC13.tgz .
ADD files/parseltongue-2.3e.tgz .
ADD files/obit_20160115.tgz .

# Install SPAM support files

RUN tar xzf spam_etc_*.tgz

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

RUN groupadd -g 1234 spamgroup && \
    useradd -m -u 1234 -g spamgroup spamuser

USER spamuser:spamgroup

ADD files/.AIPSRC .AIPSRC
RUN cat .AIPSRC

USER root
# RUN perl install.pl -n



# Configuring AIPS using the expect script which provides inputs for the
# prompts from AIPS commands. 
COPY services /root/services
COPY script.exp /usr/local/aips/

RUN apt install -y expect
RUN cd /usr/local/aips/ && \
    chmod +x script.exp && \
    ./script.exp &&\
    chmod +x LOGIN.SH



    
    
    
    
    
    
    
    
    

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
