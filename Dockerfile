
# 

FROM ubuntu:18.04


# Build
RUN apt-get update \
        && apt-get install -y --no-install-recommends git build-essential g++ autoconf automake libtool xz-utils libasound-dev yarn gdb vim yasm wget sudo ca-certificates gnupg2 docbook2x

RUN cd /opt && git clone https://github.com/open-webrtc-toolkit/owt-server.git
WORKDIR /opt/owt-server

RUN scripts/installDepsUnattended.sh


RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
RUN sudo apt-get install -y nodejs g++ 

RUN  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN npm install -g node-gyp

# This is failing...  Comment it out to run it from bash
RUN scripts/build.js -t all --check.

# TODO: Expose ports, set entry point.
EXPOSE 8000

# TODO: Set Entrypoint to binary
# Run when the container launches
# ENTRYPOINT [ "./EXECUTABLE" ]
ENTRYPOINT [ "/bin/bash" ]


