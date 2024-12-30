# syntax=docker/dockerfile:1

FROM alpine:latest AS base

FROM base AS build
WORKDIR /dynamicDnsUpdater
COPY . .

FROM base AS final

RUN apk --no-cache add curl
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
WORKDIR /dynamicDnsUpdater
COPY --from=build /dynamicDnsUpdater/ .
RUN chown -R appuser:appuser /dynamicDnsUpdater
RUN chmod +x /dynamicDnsUpdater/main.sh
USER appuser
ENTRYPOINT [ "/dynamicDnsUpdater/main.sh" ]
