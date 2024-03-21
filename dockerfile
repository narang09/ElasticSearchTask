FROM ubuntu:20.04

#JAVA INSTALLATION

RUN apt-get update && \
    apt-get install -y wget openjdk-11-jdk

RUN apt-get update && \
    apt-get install -y gnupg2 curl && \
    apt-get clean  

# ELASTICSEARCH INSTALLATION

RUN apt-get install -y curl    

RUN apt-get update && \
    apt-get install -y gnupg2 curl && \
    apt-get clean
   

RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends elasticsearch && \
    apt-get clean


# RUN groupadd -g 1000 elasticsearch && \
#     useradd -u 1000 -g 1000 -d /usr/share/elasticsearch elasticsearch

RUN getent group elasticsearch || groupadd -g 1000 elasticsearch
RUN id -u elasticsearch &>/dev/null || useradd -u 1000 -g 1000 -d /usr/share/elasticsearch elasticsearch    


WORKDIR /usr/share/elasticsearch

RUN set -ex && \
    for path in data logs config config/scripts; do \
        mkdir -p "$path" && \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

#CONFIGURATION

COPY logging.yml /usr/share/elasticsearch/config/
COPY elasticsearch.yml /usr/share/elasticsearch/config/

#START ELASTICSEARCH    

ENV PATH="/usr/share/elasticsearch/bin:${PATH}"

USER elasticsearch
CMD ["elasticsearch"]

EXPOSE 9200 9300




