#!/bin/bash

INTERFACE=$(ls /sys/class/net | grep -v lo)

WIDTH="${WIDTH:-1280}"
HEIGHT="${HEIGHT:-720}"
MANUFACTURER="${MANUFACTURER:-Onvif}"
MODEL="${MODEL:-Camera}"
SERIAL="${SERIAL:-00:01:02:03:04:05}"
HWID="${HWID:-HW_ID}"
FW_VER="${FW_VER:-1.0.0}"
TYPE="${TYPE:-H264}"


cleanup () {
    echo "Container stopped, performing cleanup..."
    kill `cat /wsdd.pid`
    kill `cat /onvif_srvd.pid`
    echo "Done"
    exit
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

if [[ -z ${URL} ]]
then
  echo "RTSP URL not provided.  Be sure to set the URL environment variable"
  exit 1
fi

if [[ -z ${SNAPSHOT_URL} ]]
then
  echo "Snapshot URL not provided.  Be sure to set the SNAPSHOT_URL environment variable"
  exit 1
fi

echo "Starting wsdd daemon"
/onvif-camera-server/wsdd \
  --if_name ${INTERFACE} \
  --type tdn:NetworkVideoTransmitter \
  --xaddr "http://%s:1000/onvif/device_service" \
  --scope "onvif://www.onvif.org/name/${MANUFACTURER}-${MODEL} \
           onvif://www.onvif.org/Profile/Streaming  \
           onvif://www.onvif.org/hardware/S_HARDWARE \
           onvif://www.onvif.org/location/S_LOCATION"

echo "Starting onvif_srvd daemon"
/onvif-camera-server/onvif_srvd \
  --ifs ${INTERFACE} \
  --scope onvif://www.onvif.org/name/${MANUFACTURER}-${MODEL} \
  --scope onvif://www.onvif.org/hardware/S_HARDWARE \
  --scope onvif://www.onvif.org/hardware/S_LOCATION \
  --scope onvif://www.onvif.org/Profile/S  \
  --scope onvif://www.onvif.org/Profile/Streaming \
  --name RTSP \
  --width ${WIDTH} \
  --height ${HEIGHT} \
  --url ${URL} \
  --snapurl ${SNAPSHOT_URL} \
  --model ${MODEL} \
  --manufacturer ${MANUFACTURER} \
  --serial_num ${SERIAL} \
  --hardware_id ${HWID} \
  --firmware_ver ${FW_VER} \
  --type ${TYPE}

while true; do sleep 1000; done &
wait

echo "onvif-camera-server exited"
