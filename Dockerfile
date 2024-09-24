FROM ubuntu:22.04 as builder
WORKDIR /
RUN apt update && apt upgrade -y

RUN apt install \
    flex bison byacc make cmake m4 autoconf unzip \
    openssl libssl-dev zlib1g-dev libcrypto++8 \
    git g++ wget -y

RUN git clone https://github.com/KoynovStas/onvif_srvd.git && \
    cd /onvif_srvd && \
    cmake -B build . -DWSSE_ON=1 -DUSE_GSOAP_STATIC_LIB=1 && \
    cmake --build build

RUN git clone https://github.com/KoynovStas/wsdd.git && \
    cd /wsdd && \
    cmake -B build . -DUSE_GSOAP_STATIC_LIB=1 && \
    cmake --build build


FROM ubuntu:22.04
RUN apt update && apt install bash dumb-init -y

COPY --from=builder \
    /onvif_srvd/build/onvif_srvd \
    /onvif-camera-server/onvif_srvd

COPY --from=builder \
    /wsdd/build/wsdd \
    /onvif-camera-server/wsdd

COPY ./docker/entrypoint.sh /

ENTRYPOINT ["dumb-init", "/entrypoint.sh"]
