FROM centos:latest

LABEL VERSION="2.0.0" \
    RUN="docker run -it -p 8080:80 appliedis/homebase:latest" \
    SOURCE="http://github.com/appliedis/homebase" \
    DESCRIPTION="Vector and raster tile server serving the OSM Planet file" \
    CLASSIFICATION="UNCLASSIFIED"

MAINTAINER Homebase Developers <https://github.com/appliedis/homebase>

ARG FEDORA_REPO=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-23
ARG GPG_CHECK=1

# Copy and unpack tileserver-gl source
COPY tileserver-gl-v2.2.0.tar.gz .
RUN tar -zxvf tileserver-gl-v2.2.0.tar.gz

ENV NODE_ENV="production"
VOLUME /tileserver-gl/data
WORKDIR /tileserver-gl/data
EXPOSE 80
ENTRYPOINT ["/tileserver-gl/run_homebase.sh"]

RUN yum -y install epel-release
RUN yum -q -y update
RUN yum -q -y upgrade

# Install centos dependencies
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install \
           cairo \
           cairo-devel \
           cairomm-devel \
           curl \
           gcc \
           gcc-c++ \
           libcurl-devel \
           libgcc.x86_64 \
           libXxf86vm-devel \
           make \
           mesa-dri-drivers \
           mesa-libgbm \
           mesa-libGL-devel \
           mesa-libGLES \
           nodejs-6.12.0 \
           nodejs-devel-6.12.0 \
           protobuf \
           protobuf-compiler \
           protobuf-devel \
           which \
           xorg-x11-server-Xvfb
RUN rm -rf /var/cache/yum

# Add the fedora repo to get updated versions of gcc and g++
RUN echo "[warning:fedora]" | tee /etc/yum.repos.d/FedoraRepo.repo
RUN echo "name=fedora" | tee -a /etc/yum.repos.d/FedoraRepo.repo
RUN echo "mirrorlist=${FEDORA_REPO}&arch=\$basearch" | tee -a /etc/yum.repos.d/FedoraRepo.repo
RUN echo "enabled=1" | tee -a /etc/yum.repos.d/FedoraRepo.repo
RUN echo "gpgcheck=${GPG_CHECK}" | tee -a /etc/yum.repos.d/FedoraRepo.repo
RUN echo "gpgkey=https://getfedora.org/static/34EC9CBA.txt" | tee -a /etc/yum.repos.d/FedoraRepo.repo
RUN yum -y update gcc

# Symlink to libcurl-gnutls
RUN ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

# Copy homebase files and install node dependencies
COPY ./src /tileserver-gl
RUN cd /tileserver-gl
RUN npm install node-gyp && npm install --production
