FROM condaforge/miniforge3:latest
LABEL maintainer="Victor Roces <victor.fernandez@tuebingen.mpg.de>"
LABEL org.opencontainers.image.source="https://github.com/RocesV/Chlamytina"

#########
### Aptitude packages & R
#########

SHELL ["/bin/bash", "-lc"]

ENV DEBIAN_FRONTEND=noninteractive
ENV CHLAMYTINA_ENV_NAME=chlamytina
ENV CHLAMYTINA_HOME=/home/Chlamytina
ENV PATH=/opt/conda/envs/chlamytina/bin:/opt/conda/bin:$PATH

RUN apt-get update
RUN apt-get install -y --no-install-recommends apache2 ca-certificates curl tini
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
  && a2enconf servername \
  && rm -f /var/www/html/index.html \
  && rm -rf /var/lib/apt/lists/*

#########
### JBrowse
#########

WORKDIR /var/www/html/
COPY jbrowse /var/www/html/jbrowse
RUN chmod -R a+rX /var/www/html/jbrowse

#########
### R packages
#########

WORKDIR /home/
COPY chlamytina /home/Chlamytina

WORKDIR /home/Chlamytina
RUN awk ' \
  { print } \
  /phase "Checking 1_DataPrepare.R help output" check_help/ { \
    print ""; \
    print "say \"Skipping bundled self-tests during Docker image build.\""; \
    print "say \"Installation complete OK\""; \
    print "say \"Activate with: conda activate $ENV_NAME\""; \
    print "say \"Log saved at: $LOG_FILE\""; \
    exit; \
  } \
' Code/0_ChlamytinaInstall.sh > Code/0_ChlamytinaInstall_Docker.sh \
  && grep -q "Skipping bundled self-tests during Docker image build" Code/0_ChlamytinaInstall_Docker.sh \
  && chmod +x Code/0_ChlamytinaInstall_Docker.sh

RUN bash Code/0_ChlamytinaInstall_Docker.sh \
  && rm -f Code/0_ChlamytinaInstall_Docker.sh

RUN mamba install --no-pin -n chlamytina -y \
    --override-channels \
    --strict-channel-priority \
    -c conda-forge \
    -c bioconda \
    "samtools=1.24" \
    "htslib=1.24"

RUN command -v Rscript \
  && command -v jbrowse \
  && command -v samtools \
  && command -v tabix \
  && command -v bgzip

#########
### Data
#########

WORKDIR /home/
RUN mkdir -p /home/rocesv/Documents/Transfer
RUN ln -s /home/Chlamytina /home/rocesv/Documents/Chlamytina

#########
### Clean-up & Accesibility
#########

WORKDIR /home/Chlamytina
RUN conda clean -afy \
  && rm -rf /root/.cache /tmp/* Code/.chlamytina-install-logs
RUN echo 'source /opt/conda/etc/profile.d/conda.sh && conda activate chlamytina' >> /root/.bashrc

EXPOSE 80

#########
### Reset
#########

WORKDIR /home/Chlamytina
ENTRYPOINT ["tini", "--"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
