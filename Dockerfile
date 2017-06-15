FROM node:7.10

LABEL VERSION="1.0.0" \
    RUN="docker run -d -p 8080:8080 docker.platform.cloud.coe.ic.gov/nga-r/homebase" \
    SOURCE="https://sc.appdev.proj.coe.ic.gov/appliedis/homebase" \
    DESCRIPTION="Vector tile server serving the OSM Planet file" \
    CLASSIFICATION="UNCLASSIFIED"

MAINTAINER Homebase Developers <https://github.com/appliedis/homebase>

# Put code at /homebase
RUN mkdir -p /homebase
COPY . /homebase
WORKDIR /homebase

RUN tar -xvzf nm-node7.10.tar.gz

EXPOSE 8080
CMD npm run server
