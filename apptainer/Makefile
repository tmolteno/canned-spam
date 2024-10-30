run:
	apptainer shell spam.sif 

build:
	mkdir -p ~/tmp
	APPTAINER_TMPDIR=~/tmp apptainer build --fakeroot spam.sif Singularity.def 

dev:
	apptainer build --sandbox spam.sif Singularity.def 
