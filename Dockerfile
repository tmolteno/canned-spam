FROM debian/eol:jessie
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

RUN curl -O https://ftp.strw.leidenuniv.nl/intema/spam/spam_20240308.tgz
RUN curl -O https://ftp.strw.leidenuniv.nl/intema/spam/spam_etc_20181208.tgz
RUN curl -O https://ftp.strw.leidenuniv.nl/intema/spam/AIPS_31DEC13.tgz
RUN curl -O https://ftp.strw.leidenuniv.nl/intema/spam/parseltongue-2.3e.tgz
RUN curl -O https://ftp.strw.leidenuniv.nl/intema/spam/obit_20160115.tgz

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

USER spamuser

USER root
# RUN perl install.pl -n
RUN touch .AIPSRC
RUN cat .AIPSRC

## Install Orbit Core

WORKDIR /build/spam
RUN ls -l
RUN tar zxf obit_20160115.tgz


## Install parseltongue

ENV PYTHONPATH="$SPAM_PATH/Obit/python:$PYTHONPATH"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SPAM_PATH/lib"

RUN aptitude install -y python-fftw

COPY test.py .
RUN python2.7 test.py

RUN tar xzf parseltongue-2.3e.tgz
WORKDIR /build/spam/parseltongue-2.3e
RUN ./configure --prefix=$SPAM_PATH/ParselTongue --with-obit=$SPAM_PATH/Obit
