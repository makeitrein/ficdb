# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ficdb,
       ecto_repos: [Ficdb.Repo]

# Configures the endpoint
config :ficdb,
       FicdbWeb.Endpoint,

       secret_key_base: "eVARjfTJRCn+y4G9MSob6/5+r+UOcSEHX0qj7LauSJU9VOuo650Xd0ImbtZn1bpA",
       render_errors: [
         view: FicdbWeb.ErrorView,
         accepts: ~w(html json)
       ],
       pubsub: [
         name: Ficdb.PubSub,
         adapter: Phoenix.PubSub.PG2
       ]
# configures quantum cron job
config :ficdb, Ficdb.Scheduler,
       jobs: [
         # Every six hours
         {"0 */6 * * *",      {Ficdb.CronCrawler, :check_for_updates, []}},
       ]


# Configures Elixir's Logger
config :logger,
       :console,
       format: "$time $metadata[$level] $message\n",
       metadata: [:user_id]


# -- Veil Configuration    Don't remove this line
config :veil,
       site_name: "Ficdb",
       email_from_name: "Ficdb Admin",
       email_from_address: "donotreply@ficdb.com",
       sign_in_link_expiry: 3_600,
       session_expiry: 86_400 * 30,
       refresh_expiry_interval: 86_400

config :veil,
       Veil.Scheduler,
       jobs: [
         # Runs every midnight to delete all expired requests and sessions
         {"@daily", {Ficdb.Veil.Clean, :expired, []}}
       ]


# -- End Veil Configuration

config :arc,
       storage: Arc.Storage.GCS,
       bucket: "ficdb.com"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
