[![Docker Image CI](https://github.com/mattgalbraith/htseq2-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/htseq2-docker-singularity/actions/workflows/docker-image.yml)
# htseq2-docker-singularity
## Build Docker container for HTSeq and (optionally) convert to Apptainer/Singularity  
A Python library to facilitate programmatic analysis of data from high-throughput sequencing (HTS) experiments. A popular component of HTSeq is htseq-count, a script to quantify gene expression in bulk and single-cell RNA-Seq and similar experiments.

## Build docker container:  

### 1. For HTSeq installation instructions:  
https://htseq.readthedocs.io/en/master/install.html   
https://github.com/htseq/htseq/blob/master/README.md  

### 2. Build the Docker Image
Docker image based on continuumio/miniconda3 and uses mamba + htseq_environment.yaml to install HTSeq 2 + dependencies

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level htseq-docker-singularity directory
docker build -t htseq:2.0.2 .
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
```bash
docker run --rm -it htseq:2.0.2 htseq-count -h
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o htseq-docker2.0.2.tar && gzip htseq-docker2.0.2.tar # = IMAGE_ID of HTSeq image
docker run -v "$PWD:/data" --rm -it singularity:1.1.5 bash -c "singularity build /data/htseq2.0.2.sif docker-archive:///data/htseq-docker2.0.2.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the htseq.sif file to the system on which you want to run HTSeq from the Singularity container

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available
```bash
# set up path to the HTSeq Singularity container
HTSEQ_SIF=path/to/htseq2.0.2.sif

# Test that HTSeq can run from Singularity container
singularity run $HTSEQ_SIF htseq-count -h # depending on system/version, singularity is now called apptainer
```