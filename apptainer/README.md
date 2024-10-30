## Running with Apptainer (or singularity) rather than docker

First build the apptainer image. This will create  a ~1.5 GB file called spam.sif. This is the SPAM application.

    make get   # if not done already
    make build
    
## Usage

    apptainer exec spam.sif

    
### Installing Apptainer


    wget https://github.com/apptainer/apptainer/releases/download/v1.3.4/apptainer_1.3.4_amd64.deb
    sudo apt install -y ./apptainer_1.3.4_amd64.deb
    wget https://github.com/apptainer/apptainer/releases/download/v1.3.4/apptainer-suid_1.3.4_amd64.deb
    sudo dpkg -i ./apptainer-suid_1.3.4_amd64.deb
