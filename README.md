# canned-spam

A containerised SPAM installation that can run on modern systems.

SPAM has lots of weird dependencies, and this is a dockerized install Hopefully this means it fully documents the process of installation of SPAM.

## Instructions

You need Docker installed, as well as docker compose (to make things easiest). Then build the docker container on your local machine.

### Pre-requisite 

The first step is to download the installation files (~600 MB in size. do this only once)

    make get

### With docker compose

Build the SPAM docker container (requires make get to have been done once)

    make build
    
Then run the SPAM docker container

    make run

This will give you a command prompt on your local machine with the SPAM container running in a directory that maps to ~/spam_store in your home directory.

### With docker

Build the SPAM docker container (requires make get to have been done once)

    make docker_build
    
Then run the SPAM docker container

    make docker_run 

This will give you a command prompt on your local machine with the SPAM container running in a directory that maps to ~/spam_store in your home directory.

## Using SPAM

Follow (http://www.intema.nl/doku.php?id=huibintema:spam:startup) to test your install.

    mkdir -p <new project directory>
    cd <new project directory>
    
    start_parseltongue.sh . 11
    
This creates a local AIPS environment, with 35 AIPS disks (work01-35) and plenty of other AIPS specific directories. The output should be

    /usr/bin/python2.7 /build/spam/ParselTongue/share/parseltongue/python/ParselTongue.py
    Python 2.7.16 (default, Mar 23 2024, 18:55:36) 
    [GCC 8.3.0] on linux2
    Type "help", "copyright", "credits" or "license" for more information.

    Welcome to ParselTongue 2.3
    >>> from spam import *

The final test is to import SPAM as a python module

    >>> from spam import *
    
If no errors, then you're good to go.


## Example script



## Details

Install instructions are here. http://www.intema.nl/doku.php?id=huibintema:spam:install.
