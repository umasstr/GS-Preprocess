FROM velaco/alpine-r:base-3.5.1

WORKDIR /tmp

COPY mcheck.h /usr/include/
RUN apk --no-cache add \
      alpine-sdk \
      bash \
      zlib-dev \
      libstdc++ \
 && wget ftp://webdata2:webdata2@ussd-ftp.illumina.com/downloads/software/bcl2fastq/bcl2fastq2-v2-20-0-tar.zip \
 && unzip bcl2fastq2-v2-20-0-tar.zip \
 && tar xzvf bcl2fastq2-v2.20.0.422-Source.tar.gz \
 && ./bcl2fastq/src/configure --prefix=/usr/local/ \
 && make \
 && make install \
 && rm -r /tmp/* \
 && rm /usr/include/mcheck.h \
 && apk --no-cache del \
      alpine-sdk \
      bash \
      zlib-dev

ENV version 0.7.17

ADD http://downloads.sourceforge.net/project/bio-bwa/bwa-${version}.tar.bz2 /tmp/

RUN apk add --update --no-cache ncurses \
        && apk add --virtual=deps --update --no-cache  musl-dev zlib-dev make  gcc \
        && cd /tmp/ && tar xjvf bwa-${version}.tar.bz2 \
        && cd /tmp/bwa-${version} \ 
        && sed -i '1i#include <stdint.h>' kthread.c \
        && sed -i[.bak] "s/u_int32_t/uint32_t/g" *.c  \
        && sed -i[.bak] "s/u_int32_t/uint32_t/g" *.h  \
        && make \
        && mv /tmp/bwa-${version}/bwa /usr/bin \
        && rm -rf /var/cache/apk/* /tmp/* \
        && apk del deps

RUN apk add python2 py-pip python-dev && pip install cutadapt
