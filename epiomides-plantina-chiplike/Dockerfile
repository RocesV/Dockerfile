FROM ubuntu:20.04
MAINTAINER Victor Roces (fernandezvictor@uniovi.es)

#########
### Aptitude packages
#########

RUN apt-get update \
&& apt-get install -y git libpthread-stubs0-dev curl wget openjdk-8-jre-headless

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

RUN conda create -n ChIPlike python=3.7 -y \
&& conda config --add channels bioconda \
&& conda install -n ChIPlike -c bioconda fastqc -y \
&& conda install -n ChIPlike -c bioconda -c conda-forge multiqc -y \
&& conda install -n ChIPlike -c bioconda cutadapt -y \
&& conda install -n ChIPlike -c bioconda bowtie2 -y \
&& conda install -n ChIPlike tbb=2020.2 -y \
&& conda install -n ChIPlike -c bioconda fastp -y \
&& conda install -n ChIPlike -c bioconda samtools=1.9 --force-reinstall -y \
&& conda install -n ChIPlike -c bioconda sambamba -y \
&& conda install -n ChIPlike -c bioconda macs2 -y \
&& conda install -n ChIPlike -c bioconda pybigwig -y \
&& conda install -n ChIPlike -c bioconda deeptoolsintervals -y \
&& conda install -n ChIPlike -c bioconda pysam -y \
&& conda install -n ChIPlike -c bioconda bedtools

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
&& curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o trim_galore.tar.gz \
&& tar xvzf trim_galore.tar.gz \
&& chmod +x faSize \
&& chmod +x bedGraphToBigWig \
&& chmod +x bedClip \
&& chmod +x bigWigAverageOverBed \
&& chmod +x bigWigToBedGraph \
&& git clone https://github.com/deeptools/deepTools
WORKDIR /home/Plantina_Utils/deepTools/
RUN python setup.py install

#########
### Import custom scripts and utilities
#########

WORKDIR /home/rocesv/
ADD bdg2bw_2 /home/Plantina_Utils/
ADD picard.jar /home/Plantina_Utils/
ENV PATH="/home/Plantina_Utils/:${PATH}"

#########
### Clean-up & Accesibility
#########

WORKDIR /home/rocesv/
RUN rm -rf /tmp/Anaconda3-2020.11-Linux-x86_64.sh \
&& rm -rf /home/Plantina_Utils/trim_galore.tar.gz \
&& mkdir /home/Transfer \
&& mv /home/rocesv/anaconda3/lib/python3.8/site-packages/deeptools/ /home/rocesv/anaconda3/envs/ChIPlike/lib/python3.7/site-packages/ \
&& rm -rf /home/rocesv/anaconda3/bin/bamCoverage

#########
### Reset
#########

WORKDIR /home/
