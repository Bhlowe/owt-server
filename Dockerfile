
# Example Dockerfile to build owt-server to /opt/otw-server
# docker build -t owt .
# docker run -p 3004:3004 -it owt
FROM ubuntu:18.04


# Build
RUN apt-get update \
        && apt-get install -y --no-install-recommends git build-essential g++ autoconf automake libtool xz-utils libasound-dev yarn gdb vim yasm wget sudo ca-certificates gnupg2 docbook2x nodejs npm libdrm-dev libva-dev

RUN  git config --global user.email "you@example.com" && \
  git config --global user.name "Your Name"


RUN cd /opt && git clone https://github.com/open-webrtc-toolkit/owt-server.git
WORKDIR /opt/owt-server

RUN scripts/installDepsUnattended.sh
RUN apt-get install -y npm
RUN npm install -g node-gyp grunt
# RUN git clone https://github.com/Intel-Media-SDK/MediaSDK.git /opt/msdk && cd /opt/msdk && mkdir build && cd build && cmake .. # && make && make install 


RUN apt install -y \
    lsb-release

ARG MEDIASDK_VER=intel-mediasdk-18.3.1
ADD https://github.com/Intel-Media-SDK/MediaSDK/releases/download/intel-mediasdk-18.3.1/MediaStack.tar.gz /mediasdk/
RUN tar -C /mediasdk -xf /mediasdk/MediaStack.tar.gz
RUN cd /mediasdk/MediaStack && ./install_media.sh
ENV MFX_HOME=/opt/intel/mediasdk

# Install js
RUN cd /opt && git clone https://github.com/open-webrtc-toolkit/owt-client-javascript.git && cd owt-client-javascript/scripts && npm install && grunt
ENV webrtc-javascript-sdk-sample-conference-dist=/opt/owt-client-javascript/dist

# This is failing...  Comment it out to run it from bash
RUN scripts/build.js -t all --check
RUN scripts/pack.js -t all --install-module --sample-path /opt/owt-client-javascript/dist
WORKDIR /opt/owt-server/dist
RUN ./bin/init-all.sh --deps


# Expose ports
EXPOSE 3004

# TODO: Set Entrypoint to binary
# Run when the container launches
# ENTRYPOINT [ "/bin/bash" ]
ENTRYPOINT [ "./bin/start-all.sh" ]


