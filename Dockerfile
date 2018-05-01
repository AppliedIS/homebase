FROM appliedis/tileserver-gl:latest

LABEL VERSION="3.1.0" \
    RUN="docker run -it -p 8080:80 appliedis/homebase:latest" \
    SOURCE="http://github.com/appliedis/homebase" \
    DESCRIPTION="Vector and raster tile server serving the OSM Planet file" \
    CLASSIFICATION="UNCLASSIFIED"

MAINTAINER Homebase Developers <https://github.com/appliedis/homebase>

# Copy Homebase assets
RUN mkdir -p /homebase
COPY src /homebase

# Use custom run script
COPY run.sh /usr/src/app
