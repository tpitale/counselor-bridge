# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :counselor_bridge,
  ecto_repos: [CounselorBridge.Repo]

# Configures the endpoint
config :counselor_bridge, CounselorBridge.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s4tyfeMCa+J32WOP+HuiV1WSuq4HvX4XzEbfJdnT2vg8+K4D6BYpL238QEXI53xd",
  render_errors: [view: CounselorBridge.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CounselorBridge.PubSub,
           adapter: Phoenix.PubSub.PG2]

 # Configures Twilio
 config :ex_twilio, account_sid: System.get_env("TWILIO_ACCOUNT_ID"),
                   auth_token:  System.get_env("TWILIO_AUTH_TOKEN")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
