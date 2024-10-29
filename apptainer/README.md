## Running with Singularity rather than docker

Set up a virtual invironment

    pip3 install spython

    spython recipe Dockerfile > Singularity.def

    sudo singularity build spam.sif Singularity.def

    
    apptainer --bind ~/spam_store:/spam_store spam.sif
