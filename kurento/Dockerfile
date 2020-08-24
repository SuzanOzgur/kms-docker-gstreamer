ARG KMS_VERSION=6.11.0
ARG UBUNTU_VERSION=bionic
FROM ubuntu:${UBUNTU_VERSION}

ADD ./entrypoint.sh /entrypoint.sh
ADD ./keys  /usr/local/etc/

MAINTAINER Suzan Ozgur <suzan.ozgur@mobiliva.com>

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

ENV MAVEN_VERSION 3.6.1
ENV MAVEN_HOME /usr/share/maven

ENV GST_DEBUG="3,Kurento*:4,kms*:4,sdp*:4,webrtc*:4,*rtpendpoint:4,rtp*handler:4,rtpsynchronizer:4,agnosticbin:4" \
    GST_DEBUG_NO_COLOR=1 \
    KMS_STUN_IP="" \
    KMS_STUN_PORT="" \
    KMS_TURN_URL=""

COPY ./entrypoint.sh /entrypoint.sh
COPY ./healthchecker.sh /healthchecker.sh

USER root
RUN chmod 655 entrypoint.sh

RUN apt-get update && apt-get install  --no-install-recommends --yes \
        gnupg \
        curl \
        sudo
 # && rm -rf /var/lib/apt/lists/*

RUN  echo 'Acquire::http::Proxy "http://proxy.kurento.org:3142";' > /etc/apt/apt.conf.d/01proxy \
  && echo 'Acquire::HTTP::Proxy::deb.nodesource.com "DIRECT";' >> /etc/apt/apt.conf.d/01proxy

RUN echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends \
 && echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends

RUN apt-get update \
     && apt-get install -y \
        git-review \
        python \
        python-configobj \
#        realpath \
	systemd \
	net-tools \
        unzip \
        zip \
  && rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver keyserver.ubuntu.com --recv EB9B1D8886F44E2A \
	&& gpg --export --armor EB9B1D8886F44E2A | apt-key add - \
	&& echo 'deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu bionic main ' > /etc/apt/sources.list.d/openjdk-13.list \
  && apt-get update \
	&& apt-get install -y --force-yes openjdk-13-jdk \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
	  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
	  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Installing nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh \
  && bash nodesource_setup.sh \
  && apt-get install -y nodejs \
  && rm nodesource_setup.sh

RUN npm -g install bower

RUN apt-get update \
  && apt-get install -y \
    git \
    apt-utils \
    graphviz \
    libxml2-dev \
    libxslt-dev \
    python-dev \
    python-pip \
    python-setuptools \
    rsync \
    zlib1g-dev \
    cmake

RUN pip install \
  javasphinx \
  lxml \
  javalang \
  docutils\
  sphinx
#==1.2.3 -> ubuntu 14.04

RUN apt-get update -y \
    && apt-get install --yes \
       pkg-config \
       bison \
       flex \
       libgstreamer1.0-dev \
       libgstreamer-plugins-base1.0-dev \
       libfontconfig1-dev \
       libfreetype6-dev

RUN apt-get update -y \
    && apt-get install --yes \
       libpng-dev \
       libcairo2-dev \
       libjpeg-dev \
       libgif-dev \
       libgstreamer-plugins-base1.0-dev \
       python-gst-1.0 \
       python3-gst-1.0 \
       python-gi-dev

RUN apt-get update -y \
    && apt-get install --yes \
       libunwind-dev \
       libdw-dev \
       libgtk-3-dev \
       libx11-dev xorg-dev  \
       libglu1-mesa \
       libglu1-mesa-dev \
       libgl1-mesa-glx \
       libgl1-mesa-dev

RUN apt-get update -y \
    && apt-get install --yes \
       libfontconfig1-dev \
       libfreetype6-dev \
       libpng-dev \
       libcairo2-dev \
       libjpeg-dev \
       libgif-dev \
       libgstreamer-plugins-base1.0-dev \
       python-gst-1.0 \
       python3-gst-1.0

RUN apt-get install -y texlive-full

RUN apt-get update -y \
  && apt-get install --no-install-recommends -y -q \
    build-essential \
    ca-certificates \
    mediainfo \
    libmediainfo-dev \
    xmlstarlet \
    jshon \
    libffi-dev \
    libssl1.0.0

RUN apt-get update && apt-get install --yes \
        python3 python3-pip python3-setuptools python3-wheel \
        devscripts \
        dpkg-dev \
        lintian \
        openssh-client \
        lsb-release \
        equivs \
        coreutils \
        ffmpeg \
        subversion \
        software-properties-common \
 && rm -rf /var/lib/apt/lists/*

# Install 'git-buildpackage'
RUN PIP_VERSION="$(python3 -c 'import pip; print(pip.__version__)')" \
   dpkg --compare-versions "$PIP_VERSION" ge "1.6.0" && ARGS="--no-cache-dir"; \
    pip3 $ARGS install --upgrade gbp
#==0.9.10 -> ubuntu 14.04

RUN	\
 	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83 && \
	add-apt-repository "deb http://ubuntu.openvidu.io/6.11.0 bionic kms6" && \
	apt-get update && \
	apt-get -y install kurento-media-server && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --yes \
        kms-chroma \
        kms-crowddetector \
        kms-platedetector \
        kms-pointerdetector \
    || true \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends --yes  \
	  libglib2.0-dev \
#          libglib2.0-0-dbg \ -> ubuntu 14.04
#          libssl1.0.0-dbg \ -> ubuntu 14.04
	  libssl1.0.0 \
	  libssl-dev \
          gstreamer1.5-plugins-base-dbg \
          gstreamer1.5-plugins-good-dbg \
          gstreamer1.5-plugins-ugly-dbg \
          gstreamer1.5-plugins-bad-dbg \
          gstreamer1.5-libav-dbg \
          libgstreamer1.5-0-dbg \
          libnice10-dbgsym \
          libsrtp1-dbg \
          openwebrtc-gst-plugins-dbg \
          kmsjsoncpp-dbg \
          kms-jsonrpc-dbg \
          kms-core-dbg \
          kms-elements-dbg \
          kms-filters-dbg \
          kurento-media-server-dbg

RUN apt-get update && apt-get autoremove && apt-get -f install && apt-get install --yes \
        nano \
        sqlite \
        libsqlite3-dev \
        libevent-dev \
        pkg-config \
        iproute2 \
        autoconf \
        pkg-config \
        autopoint \
        autotools-dev \
        automake \
     || true \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get clean && apt-get install --yes \
        sudo \
        sqlite3 \
        gcc \
        libtool \
        gstreamer-1.5 \
        aclocal \
        pkg-config \
#        libssl1.0.0 \ -> ubuntu 14.04
#        libssl1-dev \ -> ubuntu 14.04
#        libssl-dev \ -> ubuntu 14.04
	libssl1.0.0 \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        gstreamer1.5-plugins \
        libsrtp0 \
     || true \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://packages.chef.io/files/stable/chefdk/4.10.0/ubuntu/18.04/chefdk_4.10.0-1_amd64.deb \
  && dpkg -i chefdk_4.10.0-1_amd64.deb \
     && apt-get install -y \
        ruby \
        ruby-dev \
#	nscd \ -> ubuntu 14.04

RUN gem install foodcritic -v '~>4.0.0'


RUN apt-get update && apt-get autoremove && apt-get -f install && apt-get install --yes \
        libhiredis-dev \
        make \
     || true \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -y dist-upgrade && apt-get install --yes \
        gdebi-core \
        libpq-dev \
        libsqlite3 \
        coturn \
        wget \
     || true \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
   libevent-core-2.1-6 \
   libevent-extra-2.1-6 \
   libevent-openssl-2.1-6 \
   libevent-pthreads-2.1-6 \
   libhiredis-dev \
   libmysqlclient20 \
   libpq-dev \
   telnet

RUN apt-get update --fix-missing && apt-get upgrade -y &&  dpkg --configure -a && sudo apt-get install -f && apt-get update && apt-get install -y cmake 
# if required open and build docker-compose
 #&& cd /opt && mkdir kurento && cd kurento && git clone https://github.com/Kurento/kurento-media-server.git \
# && git clone https://github.com/Kurento/kms-core.git \
# && git clone https://github.com/Kurento/kms-elements.git \
# && git clone https://github.com/Kurento/kms-filters.git \
# && git clone https://github.com/Kurento/kms-jsonrpc.git \
# && git clone https://github.com/Kurento/kms-chroma.git \
# && git clone https://github.com/Kurento/kms-cmake-utils.git \
# && git clone https://github.com/Kurento/kms-crowddetector.git \
# && git clone https://github.com/Kurento/kms-datachannelexample.git \
# && git clone https://github.com/Kurento/kms-opencv-plugin-sample.git \
# && git clone https://github.com/Kurento/kms-platedetector.git \
# && git clone https://github.com/Kurento/kms-plugin-sample.git \
# && git clone https://github.com/Kurento/kms-pointerdetector.git \
# && git clone https://github.com/Kurento/kurento-module-creator.git

#RUN cd /opt/kurento/kurento-media-server && git checkout 6.11.0 \
# && cd /opt/kurento/kms-core && git checkout 6.11.0 \
# && cd /opt/kurento/kms-filters && git checkout 6.11.0 \
# && cd /opt/kurento/kms-elements && git checkout 6.11.0 \
# && cd /opt/kurento/kms-jsonrpc && git checkout 1.1.3 \
# && cd /opt/kurento/kms-cmake-utils && git checkout 1.4.0 \
# && cd /opt/kurento/kms-crowddetector && git checkout 6.6.0 \
# && cd /opt/kurento/kms-chroma && git checkout 6.6.0 \
# && cd /opt/kurento/kms-datachannelexample && git checkout 6.6.0 \
# && cd /opt/kurento/kms-platedetector && git checkout 6.6.0 \
# && cd /opt/kurento/kms-pointerdetector && git checkout 6.6.0 \
# && cd /opt/kurento/kurento-module-creator && git checkout 4.0.8 \
# && cd /opt/kurento/kurento-media-server \
# && sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
# && debuild -us -uc

#RUN cd /opt/kurento/kurento-module-creator \
# && sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
# && debuild -us -uc \
# && cd /opt/kurento/kms-core \
# && sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
# && debuild -us -uc

#RUN cd /opt/kurento/kms-elements \
# && sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
# && sed -i 's/add_subdirectory(tests)/#add_subdirectory(tests)/g' CMakeLists.txt \
# && sed -i 's/override_dh_auto_test/#override_dh_auto_test/g'  debian/rules \
# && sed -i 's/dh_auto_build -- -j2 check ARGS=-j10/#dh_auto_build -- -j2 check ARGS=-j10/g'  debian/rules \
# && debuild -us -uc \
# && cd /opt/kurento/kms-filters \
# && sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
# && sed -i 's/add_subdirectory(tests)/#add_subdirectory(tests)/g' CMakeLists.txt \
# && debuild -us -uc \
# && cd /opt/kurento/kms-jsonrpc \
# && sudo apt-get install -y $(cat debian/control | sed -e "s/$/\!\!/g" | tr -d '\n' | sed "s/\!\! / /g" | sed "s/\!\!/\n/g" | grep "Build-Depends" | sed "s/Build-Depends: //g" | sed "s/([^)]*)//g" | sed "s/, */ /g") \
# && debuild -us -uc

RUN wget http://turnserver.open-sys.org/downloads/v4.5.1.1/turnserver-4.5.1.1.tar.gz \
          tar -xzvf turnserver-4.5.1.1.tar.gz \
          cp /turnserver-4.5.1.1/examples/etc/turn_client_cert.pem /usr/local/etc/ \
          cp /turnserver-4.5.1.1/examples/etc/turn_client_pkey.pem /usr/local/etc/ \
          cp /turnserver-4.5.1.1/examples/etc/turn_server_cert.pem /usr/local/etc/ \
          cp /turnserver-4.5.1.1/examples/etc/turn_server_pkey.pem /usr/local/etc/ \
     || true \
 && rm -rf /var/lib/apt/lists/*

RUN ./turnserver-4.5.1.1/configure \
          make && make install \
     || true \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update

ENV TURN_USERNAME biotekno
ENV TURN_PASSWORD biotekno
ENV REALM biotekno.org
ENV NAT false

EXPOSE 8888
EXPOSE 3478 3479 3478/udp 3479/udp 80 80/udp
EXPOSE 5349 5350 5349/udp 5350/udp 443 443/udp

HEALTHCHECK --start-period=15s --interval=30s --timeout=3s --retries=1 CMD /healthchecker.sh

CMD /gstreamer.sh
ENTRYPOINT ["/entrypoint.sh"]
