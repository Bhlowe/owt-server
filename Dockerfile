
# Example Dockerfile to build owt-server to /opt/otw-server

FROM ubuntu:18.04


# Build
RUN apt-get update \
        && apt-get install -y --no-install-recommends git build-essential g++ autoconf automake libtool xz-utils libasound-dev yarn gdb vim yasm wget sudo ca-certificates gnupg2 docbook2x nodejs npm 

RUN cd /opt && git clone https://github.com/open-webrtc-toolkit/owt-server.git
WORKDIR /opt/owt-server

RUN scripts/installDepsUnattended.sh

RUN npm install -g node-gyp

# This is failing...  Comment it out to run it from bash
RUN scripts/build.js -t all --check.

# TODO: Expose ports, set entry point.
EXPOSE 8000

# TODO: Set Entrypoint to binary
# Run when the container launches
# ENTRYPOINT [ "./EXECUTABLE" ]
ENTRYPOINT [ "/bin/bash" ]


