FROM pegi3s/cutadapt:latest

COPY mcheck.h /usr/include/

RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    unzip \
    cmake \
    zlib1g-dev \
	samtools \
	bwa 
	
 RUN wget ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-tar.zip 
 RUN unzip bcl2fastq2-v2-20-0-tar.zip 
 RUN gunzip bcl2fastq2-v2.20.0.422-Source.tar.gz 
 RUN tar xvf bcl2fastq2-v2.20.0.422-Source.tar 
 RUN cd bcl2fastq && \
 ./src/configure --prefix=/usr/local/ --with-cmake=/usr/bin/cmake && make && make install 
 RUN rm -rf bcl2fastq 
 RUN rm /usr/include/mcheck.h 
 RUN apt-get purge -y \
    build-essential \
    wget \
    unzip \
    cmake \
    zlib1g-dev 
 RUN apt-get autoremove -y \
 && apt-get clean 
 RUN rm -rf /var/lib/apt/lists/*
 
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev

RUN apt-get update && apt-get install -y lsb-release gnupg \
    && echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" >> /etc/apt/sources.list.d/cran.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && apt-get update \
    && apt-get install -y r-base


	
RUN R -e "install.packages('BiocManager')" 
RUN R -e "BiocManager::install('GUIDEseq')" 
RUN apt-get clean 

COPY src/gs_preprocess.sh /usr/local/bin/gs_preprocess
RUN chmod +x /usr/local/bin/gs_preprocess

COPY src/gs_preprocess.sh /usr/local/bin/gs_preprocess
RUN chmod +x /usr/local/bin/gs_preprocess


ENTRYPOINT []
CMD ["/bin/bash"]

