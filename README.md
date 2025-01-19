# Dynamic IP updater
A simple bash script to automatically update a dynamic ip address using [Duckdns](https://www.duckdns.org/). Uses http requests to [api.ipify](https://api.ipify.org/) to determine the current ip.

## Docker



### Pull Docker Image
1. Use `docker run -d -e DOMAIN_NAME=sample_domain_name -e API_KEY=sample_api_key anthonyargatoff/duckdns-updater:latest` to pull and run the docker image.
2. Or, use the `compose.yaml` file, and add the env variables.

## Local Development

1. Create a local `.env` file, where you will put in your duckdns api key and domain name.
2. Compile the script with `gcc main.cpp -lcurl`, then run with `./main`.

