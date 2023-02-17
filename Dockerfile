################## BASE IMAGE ######################
FROM --platform=linux/amd64 continuumio/miniconda3:22.11.1
# Debian-based image with Miniconda3 and some utils

################## METADATA ######################
LABEL base_image="continuumio/miniconda3:22.11.1"
LABEL version="1.0.0"
LABEL software="HTSeq"
LABEL software.version="2.0.2"
LABEL about.summary="HTSeq is a Python package for analysis of high-throughput sequencing data."
LABEL about.home="https://htseq.readthedocs.io/en/master/index.html"
LABEL about.documentation="https://htseq.readthedocs.io/en/master/index.html"
LABEL about.license_file="https://github.com/htseq/htseq/blob/master/LICENSE"
LABEL about.license="GNU GPL v3"

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>

################## INSTALLATION ######################
ENV DEBIAN_FRONTEND noninteractive
ARG ENV_NAME="htseq"

# Install the conda environment
COPY htseq_environment.yaml /
RUN conda install -n base conda-forge::mamba

RUN mamba env create --name htseq --file /htseq_environment.yaml && \
	conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/${ENV_NAME}/bin:$PATH

# # Initial successful build workflow: 
# RUN mamba env create --name htseq --file /environment.yml # with python numpy pysam pyBigWig matplotlib
# RUN mamba install -y -n htseq HTSeq=2.0.2 -c bioconda -c conda-forge && conda clean -a
# # After this run image, activate htseq env, and write out environment.yaml to capture all the packages and versions etc for reproducible install:
# conda activate htseq
# conda env export > htseq_environment.yaml
# # finally, replace the mamba env create + mamba install steps with single mamba env create pointing to this file