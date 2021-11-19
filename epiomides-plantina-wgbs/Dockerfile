FROM r-base:3.6.2
MAINTAINER Victor Roces (fernandezvictor@uniovi.es)

#########
### Aptitude packages
#########

RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
&& apt-get update \
&& apt install -y zlib1g-dev libpng-dev libgd-dev build-essential gcc-9-base \
   libxml2-dev libssl-dev libcurl4-openssl-dev libopenblas-dev uuid-dev \
&& apt-get install -y csh git libpthread-stubs0-dev curl wget

#########
### Conda 
#########

WORKDIR /tmp/
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh \
&& bash Anaconda3-2020.11-Linux-x86_64.sh -b -p /home/rocesv/anaconda3
WORKDIR /home/rocesv/
RUN /bin/bash -c "source ~/.bashrc"
ENV PATH="/home/rocesv/anaconda3/bin:${PATH}"

#########
### Pkgs install with Conda
#########

RUN conda create -n WGBS python=3.7 -y \
&& conda config --add channels bioconda \
&& conda config --add channels conda-forge \
&& conda install -n WGBS -c bioconda fastqc -y \
&& conda install -n WGBS -c bioconda -c conda-forge multiqc -y \
&& conda install -n WGBS -c bioconda bowtie2 -y \
&& conda install -n WGBS tbb=2020.2 -y \
&& conda install -n WGBS -c bioconda fastp -y \
&& conda install -n WGBS -c bioconda samtools=1.9 --force-reinstall -y \
&& conda install -n WGBS -c bioconda bedtools -y \
&& conda install -n WGBS -c bioconda trim-galore -y

#########
### Pkgs install without Conda: Piccard-Utils and trim_galore
#########

RUN mkdir /home/Plantina_Utils/
WORKDIR /home/Plantina_Utils/
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v369/faSize \
&& wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig \
&& wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedClip \
&& wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bigWigAverageOverBed \
&& wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bigWigToBedGraph \
&& wget https://github.com/FelixKrueger/Bismark/archive/refs/tags/0.23.1.tar.gz \
&& mv /home/Plantina_Utils/0.23.1.tar.gz /home/Plantina_Utils/Bismark.tar.gz \
&& tar xvzf Bismark.tar.gz \ 
&& chmod +x faSize \
&& chmod +x bedGraphToBigWig \
&& chmod +x bedClip \
&& chmod +x bigWigAverageOverBed \
&& chmod +x bigWigToBedGraph

#########
### Import custom scripts and utilities
#########

WORKDIR /home/rocesv/
ADD bdg2bw_2 /home/Plantina_Utils/
ENV PATH="/home/Plantina_Utils/:${PATH}"
ADD Rpkgs_Docker.R /home/rocesv/
RUN Rscript --vanilla Rpkgs_Docker.R

#########
### Clean-up & Accesibility
#########

WORKDIR /home/rocesv/
RUN rm -rf /tmp/Anaconda3-2020.11-Linux-x86_64.sh \
&& rm -rf /home/Plantina_Utils/Bismark.tar.gz \
&& mkdir /home/Transfer \
&& rm -rf Rpkgs_Docker.R

#########
### Reset
#########

WORKDIR /home/
