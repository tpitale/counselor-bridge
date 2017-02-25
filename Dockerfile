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

# TODO: we need to set MIX_ENV=prod for compilation
#   can be done with --build-arg maybe
RUN mix compile

CMD ["mix", "phoenix.server"]
