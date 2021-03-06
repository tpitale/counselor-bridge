# Elixir 1.4.1: https://hub.docker.com/_/elixir/
FROM elixir:1.4.1-slim
LABEL maintainer Tony Pitale <tpitale@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y git

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app
ADD mix.exs mix.lock /app/

RUN mix deps.get

ADD . /app

ARG BUILD_ENV=dev
ENV MIX_ENV=$BUILD_ENV

RUN mix compile

CMD elixir --sname $SNAME --cookie $COOKIE -S mix phoenix.server
