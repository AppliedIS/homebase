FROM node:6-stretch

LABEL VERSION="2.0.0" \
    RUN="docker run -it -p 8080:80 appliedis/homebase:latest" \
    SOURCE="http://github.com/appliedis/homebase" \
    DESCRIPTION="Vector and raster tile server serving the OSM Planet file" \
    CLASSIFICATION="UNCLASSIFIED"

MAINTAINER Homebase Developers <https://github.com/appliedis/homebase>

COPY tileserver-gl-v2.2.0.tar.gz .
RUN tar -zxvf tileserver-gl-v2.2.0.tar.gz

ENV NODE_ENV="production"
VOLUME /tileserver-gl/data
WORKDIR /tileserver-gl/data
EXPOSE 80
ENTRYPOINT ["/tileserver-gl/run_homebase.sh"]

RUN apt-get -qq update \
&& DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apt-transport-https \
    curl \
    unzip \
    build-essential \
    python \
    libcairo2-dev \
    libgles2-mesa-dev \
    libgbm-dev \
    libllvm3.9 \
    libprotobuf-dev \
    libxxf86vm-dev \
    xvfb \
&& apt-get clean

COPY ./src /tileserver-gl
RUN cd /tileserver-gl && npm install --production
