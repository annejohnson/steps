# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :steps,
  ecto_repos: [Steps.Repo]

# Configures the endpoint
config :steps, Steps.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ryfWyiA50K2HYPQLDi4k4LGitp4jGcCkt1v5581O+85Veyy8VgUOJ2MCrLOIKFWj",
  render_errors: [view: Steps.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Steps.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Guardian
# TODO: Configure separately per-environment
config :guardian, Guardian,
  issuer: "Steps",
  ttl: { 30, :days },
  secret_key: "qXXBsp8!YoS70@fkCAP5Yu^4",
  serializer: Steps.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
