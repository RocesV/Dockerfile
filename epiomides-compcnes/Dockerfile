FROM r-base:3.6.2
MAINTAINER Victor Roces (fernandezvictor@uniovi.es)

#########
### Part1 Aptitude packages & R
#########

RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list \
&& apt-get update \
&& apt install -y zlib1g-dev libpng-dev libgd-dev build-essential gcc-9-base \
   libxml2-dev libssl-dev libcurl4-openssl-dev libopenblas-dev uuid-dev \
&& apt-get install -y csh git libpthread-stubs0-dev curl

#########
### LASTZ
#########

WORKDIR /home/rocesv/
RUN wget www.bx.psu.edu/~rsharris/lastz/lastz-1.04.03.tar.gz \
&& tar -xvf lastz-1.04.03.tar.gz \
&& mkdir lastz_install
ARG LASTZ_INSTALL=/home/rocesv/lastz_install
ENV PATH="${LASTZ_INSTALL}:${PATH}"
WORKDIR /home/rocesv/lastz-distrib-1.04.03/src/
RUN sed -i -e 's/-Werror//g' Makefile \
&& make \
&& make install \
&& make test \
&& make lastz_32 allowBackToBackGaps=ON \
&& make install_32  

#########
### Kent Utils & Hiller GenomeAlignmentTools            
#########

WORKDIR /home/rocesv/
RUN mkdir HillerGenomeUtils
WORKDIR /home/rocesv/HillerGenomeUtils
RUN git clone https://github.com/hillerlab/GenomeAlignmentTools.git
WORKDIR /home/rocesv/HillerGenomeUtils/GenomeAlignmentTools/kent/src
RUN make
ENV PATH="/home/rocesv/HillerGenomeUtils/GenomeAlignmentTools/kent/bin:${PATH}"
ARG KENTSRC_DIR=/home/rocesv/HillerGenomeUtils/GenomeAlignmentTools/kent/src/
WORKDIR /home/rocesv/HillerGenomeUtils/GenomeAlignmentTools/src/
ARG MACHTYPE=x86_64
RUN make
ENV PATH="/home/rocesv/HillerGenomeUtils/GenomeAlignmentTools/bin:${PATH}"

#########
### LAST & Dependencies           
#########

WORKDIR /home/rocesv/
RUN mkdir /home/rocesv/last_install
WORKDIR /home/rocesv/last_install
RUN wget http://last.cbrc.jp/last-1047.zip \
&& unzip last-1047.zip \
&& rm last-1047.zip
WORKDIR /home/rocesv/last_install/last-1047/
RUN make \
&& make install
ENV PATH="/home/rocesv/last_install/last-1047/scripts:${PATH}"
ENV PATH="/home/rocesv/last_install/last-1047/src:${PATH}"

WORKDIR /tmp/
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh \
&& bash Anaconda3-2020.11-Linux-x86_64.sh -b -p /home/rocesv/anaconda3
WORKDIR /home/rocesv/
RUN /bin/bash -c "source ~/.bashrc"
ENV PATH="/home/rocesv/anaconda3/bin:${PATH}"

RUN conda install -c conda-forge parallel -n base \
&& mv /home/rocesv/anaconda3/bin/parallel /usr/local/bin/ 

#########
### UCSC Utils & Mapping tools
#########

WORKDIR /home/rocesv/lastz_install/
RUN wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v369/faToTwoBit \
&& wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v369/faSize \
&& chmod +x faToTwoBit \
&& chmod +x faSize \
&& conda install -c bioconda blat -n base \
&& mv /home/rocesv/anaconda3/bin/blat /usr/local/bin/

#########
### R packages
#########
 
WORKDIR /home/rocesv/Documents/Docker/CNEs_Docker
ADD Rpkgs_Docker.R /home/rocesv/Documents/Docker/CNEs_Docker/Rpkgs_Docker.R
RUN Rscript --vanilla Rpkgs_Docker.R

#########
### Clean-up & Accesibility
#########

WORKDIR /home/rocesv/Documents/Docker/CNEs_Docker/
RUN rm -rf Rpkgs_Docker.R \
&& rm -rf /tmp/Anaconda3-2020.07-Linux-x86_64.sh

#########
### Reset
#########

WORKDIR /home/
