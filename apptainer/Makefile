run:
	apptainer run --bind ~/spam_store:/spam_store spam.sif 

build:
	mkdir -p ~/tmp
	APPTAINER_TMPDIR=~/tmp apptainer build spam.sif Singularity.def 

dev:
	apptainer build --sandbox spam.sif Singularity.def 
