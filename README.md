# AdvocateBridge #

AdvocateBridge provides the realtime SMS bridge between twilio and makes it available for Advocate to use.

## Setup ##

1. clone
2. install elixir (macOS `brew install elixir`)
3. `mix local.hex`
4. `mix local.rebar`
5. `mix deps.get`

*Note:* DB creation/migrations are handled in Advocate

## Running ##

`mix phoenix.server`

## Advocate (UI) ##

https://github.com/tpitale/advocate

## Local Docker Setup ##

You can run all services together using https://github.com/tpitale/advocate-provision.

If you need to run one at a time follow the steps below:

### Postgres Setup for Docker ###

*Note:* You may have done this as part of Advocate setup

1. `sudo ifconfig lo0 alias 10.200.10.1/24`
2. Trust all postgresql connections from 10.200.10.1
3. Change `listen_addresses = '*'` OR `listen_addresses = 'localhost,10.200.10.1'

### ENV ###

*Note:* we advise installing `autoenv` (on macOS `brew install autoenv`) which loads `.env` when you `cd` into the project

1. `cp .env.sample .env`
2. configure `.env` with your username/password

### Run Docker Locally ###

`make run`

*Note:* while running locally, you can open a new terminal and run `make shell`

### TODO ###

1. configure `mix compile` to build in `MIX_ENV=prod` for production

## Build && Release ##

*Note:* Be sure to have `$DOCKER_REGISTRY` set to the registry you would like to use

`make release` will:

1. build
2. tag latest
3. push it to the registry
