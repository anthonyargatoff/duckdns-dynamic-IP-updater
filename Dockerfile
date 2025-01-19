# syntax=docker/dockerfile:1

FROM alpine:latest AS base

FROM base AS build
RUN apk add g++ curl-dev
RUN mkdir dynamicDnsUpdater
COPY ./main.cpp /dynamicDnsUpdater
RUN g++ -o /dynamicDnsUpdater/dynamicDnsUpdater /dynamicDnsUpdater/main.cpp -lcurl

FROM base AS final
ARG UID=10001
RUN apk add --no-cache libcurl libstdc++ libgcc
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser
COPY --from=build /dynamicDnsUpdater/dynamicDnsUpdater /bin/
RUN env
ENTRYPOINT ["/bin/dynamicDnsUpdater" ]
