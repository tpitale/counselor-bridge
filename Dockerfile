FROM elixir:1.4.1-slim as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git build-essential

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix hex.info

WORKDIR /app

ADD mix.exs mix.lock ./

RUN mix deps.get

ADD . .

ARG BUILD_ENV=dev
ENV MIX_ENV=$BUILD_ENV

RUN mix phoenix.digest
RUN mix release

### RUNNER ###
FROM debian:jessie-slim

RUN apt-get -qq update && apt-get -qq install libssl1.0.0 libssl-dev

WORKDIR /app

ARG BUILD_ENV=dev
ENV MIX_ENV=$BUILD_ENV

COPY --from=builder /app/_build/$MIX_ENV/rel/advocate_bridge .

ENV REPLACE_OS_VARS=true

CMD ["/app/bin/advocate_bridge", "foreground"]
