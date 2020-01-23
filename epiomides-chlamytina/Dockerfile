FROM r-base:3.6.2
MAINTAINER Victor Roces (fernandezvictor@uniovi.es)

#########
### Aptitude packages & R
#########

RUN apt-get update
RUN apt install -y libxml2-dev libssl-dev libcurl4-openssl-dev libopenblas-dev
RUN apt install -y curl zip apache2
RUN apt install -y build-essential zlib1g-dev libpng-dev libgd-dev

#########
### JBrowse
#########

WORKDIR /var/www/
RUN curl -L -O https://github.com/GMOD/jbrowse/releases/download/1.16.6-release/JBrowse-1.16.6.zip 
RUN unzip JBrowse-1.16.6.zip
RUN mv JBrowse-1.16.6 /var/www/html/jbrowse
WORKDIR /var/www/html/
RUN chown -R `whoami` /var/www/html
RUN chmod -R 755 /var/www
WORKDIR /var/www/html/jbrowse
RUN ./setup.sh
WORKDIR /
RUN rm /var/www/JBrowse-1.16.6.zip

#########
### R packages
#########
 
WORKDIR /home/rocesv/Documents/Docker/
ADD Rpkgs_Docker.R /home/rocesv/Documents/Docker/Rpkgs_Docker.R
RUN Rscript --vanilla Rpkgs_Docker.R

#########
### Data
#########

WORKDIR /home/
RUN apt-get install -y git
RUN git clone https://github.com/RocesV/Chlamytina

WORKDIR /home/rocesv/Documents/Docker/
ADD data /var/www/html/jbrowse/data

WORKDIR /home/rocesv/Documents/Docker/
ADD JBrowse /home/rocesv/Documents/Genome_browser_data/JBrowse
WORKDIR /home/rocesv/Documents/
RUN mkdir Transfer

#########
### Clean-up & Accesibility
#########

WORKDIR /home/rocesv/Documents/Docker/
RUN rm -rf Rpkgs_Docker.R
EXPOSE 80

#########
### Reset
#########

WORKDIR /home/
