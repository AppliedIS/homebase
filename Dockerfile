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
RUN tar xvfz tileserver-gl-v2.2.0.tar.gz

ENV NODE_ENV="production"
VOLUME /tileserver-gl/data
WORKDIR /tileserver-gl
EXPOSE 80
ENTRYPOINT ["/tileserver-gl/run_homebase.sh"]

# Install centos dependencies and add fedora repo to get updated version of gcc
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install epel-release \
    && yum -y install \
           cairo \
           cairo-devel \
           gcc \
           gcc-c++ \
           make \
           mesa-dri-drivers \
           mesa-libGL-devel \
           mesa-libGLES \
           nodejs-6.12.0 \
           protobuf-devel \
           which \
           xorg-x11-server-Xvfb \
    && echo "[warning:fedora]" | tee /etc/yum.repos.d/FedoraRepo.repo \
    && echo "name=fedora" | tee -a /etc/yum.repos.d/FedoraRepo.repo \
    && echo "mirrorlist=${FEDORA_REPO}&arch=\$basearch" | tee -a /etc/yum.repos.d/FedoraRepo.repo \
    && echo "enabled=1" | tee -a /etc/yum.repos.d/FedoraRepo.repo \
    && echo "gpgcheck=${GPG_CHECK}" | tee -a /etc/yum.repos.d/FedoraRepo.repo \
    && echo "gpgkey=https://getfedora.org/static/34EC9CBA.txt" | tee -a /etc/yum.repos.d/FedoraRepo.repo \
    && yum -y update gcc \
    && rm -rf /var/cache/yum

# Symlink to libcurl-gnutls
RUN ln -s /usr/lib64/libcurl.so.4 /usr/lib64/libcurl-gnutls.so.4

# Copy homebase files
COPY src .

COPY node_modules.tar.gz .
RUN tar xvfz node_modules.tar.gz
