# Dynamic IP updater
A simple bash script to automatically update a dynamic ip address using [Duckdns](https://www.duckdns.org/). Uses http requests to [api.ipify](https://api.ipify.org/) to determine the current ip.

## Steps

1. Create a local copy of `config.sh` where you will put in your duckdns api token and domain.
2. Run the script with `bash main.sh`

## Docker
1. Copy the image from https://hub.docker.com/repository/docker/anthonyargatoff/duckdns-updater
1. Create a _config.sh_ file.
1. Start the docker container with `source config.sh && DOMAIN=$DOMAIN API_TOKEN=$API_TOKEN sudo docker compose up` to load variables.