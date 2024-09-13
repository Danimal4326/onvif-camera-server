FROM ubuntu:22.04 as build
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
RUN apt update && \
    apt install python3 sudo iproute2 -y

COPY --from=build /onvif_srvd/build/onvif_srvd /onvif-camera-server/onvif_srvd
COPY --from=build /wsdd/build/wsdd /onvif-camera-server/wsdd
COPY main.py /onvif-camera-server/main.py

RUN chmod +x /onvif-camera-server/main.py
EXPOSE 1000
#CMD ["/onvif-camera-server/main.py", "eth0", "/onvif-camera-server"]
#ENTRYPOINT ["python3"]
