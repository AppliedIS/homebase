FROM centos:latest

LABEL VERSION="2.0.0" \
    RUN="docker run -it -p 8080:80 appliedis/homebase:latest" \
    SOURCE="http://github.com/appliedis/homebase" \
    DESCRIPTION="Vector and raster tile server serving the OSM Planet file" \
    CLASSIFICATION="UNCLASSIFIED"

MAINTAINER Homebase Developers <https://github.com/appliedis/homebase>

# Copy and unpack tileserver-gl source
COPY tileserver-gl-2.1.0.tar.gz .
RUN tar -zxvf tileserver-gl-2.1.0.tar.gz

ENV NODE_ENV="production"
VOLUME /tileserver-gl/data
WORKDIR /tileserver-gl/data
EXPOSE 80
ENTRYPOINT ["/tileserver-gl/run_homebase.sh"]

# Install centos dependencies
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs \
           cairo \
           cairo-devel \
           gcc-c++ \
           libcurl-devel \
           libgcc.x86_64 \
           libXxf86vm-devel \
           make \
           mesa-libGL-devel \
           mesa-libgbm \
           mesa-libGLES \
           protobuf-devel \
           xorg-x11-server-Xvfb
RUN rm -rf /var/cache/yum

# Symlink to libcurl-gnutls
RUN ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

# Copy homebase files and install node dependencies
COPY ./src /tileserver-gl
RUN cd /tileserver-gl
RUN npm install node-gyp && npm install --production
