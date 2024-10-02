## Overview

This project provides a docker container to simulate a ONVIF compliant camera. It will serve the RTSP URL provided to the container and make the 'camera' discoverable to ONVIF NVRs

> [!NOTE]  
> This project started as a fork from [kate-goldenring/onvif-camera-mocking](https://github.com/kate-goldenring/onvif-camera-mocking)

If you want to use the container without building it, you can download it using the following command:

```bash
docker pull docker.io/danimal4326/onvif-camera-server:latest
```

Docker Hub: [https://hub.docker.com/r/danimal4326/onvif-camera-server](https://hub.docker.com/r/danimal4326/onvif-camera-server)


## Getting started

#### Build the Docker Container

    ```sh
    git clone https://github.com/Danimal4326/onvif-camera-server.git
    cd onvif-camera-server
    docker build .
    ```
#### Start the container

The container accepts the following environment variables:
| Name          | Description                                       | Default<br>Value                                      | Required  |
|-------------- |-------------------------------------------------  |-----------------------------------------------------  |---------- |
| URL           | Url of camera feed. (Be sure to include the port) | N/A                                                   | Y         |
| SNAPSHOT_URL  | Url of camera static image                        | N/A                                                   | N         |
| INTERFACE     | Interface to use                                  | (First Interface alphabetically not including 'lo')   | N         |
| WIDTH         | Width in pixels of the video feed                 | 1280                                                  | N         |
| HEIGHT        | Height in pixels of the video feed                | 720                                                   | N         |
| MANUFACTURER  | Manufacturer name                                 | Onvif                                                 | N         |
| MODEL         | Camera model                                      | Camera                                                | N         |
| SERIAL        | Serial number                                     | 00:01:02:03:04:05                                     | N         |
| HWID          | Hardware ID                                       | 1234                                                  | N         |
| FWVER         | Firmware version                                  | 1.0.0                                                 | N         |
| TYPE          | Encoding of the video feed                        | H264                                                  | N         |

  ```bash
URL - URL to serve - Required
SNAPSHOT_URL - Static image to server
INTERFACE - Interface to use - Optional - Default
WIDTH=1280
HEIGHT=720
MANUFACTURER=Onvif
MODEL=Camera
SERIAL=00:01:02:03:04:05
HWID=HW_ID
FWVER=1.0.0
TYPE=H264
  ```

  ```yaml
services:

  onvif-camera-server:

    container_name: onvif-camera-server

    image: 'localhost/onvif-camera-server:latest'

    restart: always

    network_mode: host

    environment:
      - URL='rtsp://camera.url:8554/feed1'
      - SNAPSHOT_URL='http://camera.url/image.jpg'
      - MANUFACTURER=MyManufacturer
      - MODEL=MyModel

    ```

## Resources

- [WSDD - ONVIF WS-Discovery server](https://github.com/KoynovStas/wsdd)
- [ONVIF Device(IP camera) Service server](https://github.com/KoynovStas/onvif_srvd)
- [ONVIF-rs](https://github.com/lumeohq/onvif-rs)
- [ONVIF Org](https://www.onvif.org/)
- [AKS Edge Essentials](https://learn.microsoft.com/en-us/azure/aks/hybrid/aks-edge-overview)
