# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :commish,
  ecto_repos: [Commish.Repo]

# Configures the endpoint
config :commish, Commish.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qrOSKsBsJC46Lsk5behiuse9i2HoMz4D8VuU9Uwa2w0/aE1DRzNtShPTzco+RInR",
  render_errors: [view: Commish.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Commish.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
