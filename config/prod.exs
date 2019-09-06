use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# FicdbWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.

# GIGALIXIR
config :ficdb, FicdbWeb.Endpoint,
   url: [host: System.get_env("RENDER_EXTERNAL_HOSTNAME") || "localhost", port: 80],
   cache_static_manifest: "priv/static/cache_manifest.json"

config :ficdb, Ficdb.Repo,
   adapter: Ecto.Adapters.Postgres,
   username: System.get_env("DB_USERNAME"),
   password: System.get_env("DB_PASSWORD"),
   database: System.get_env("DB_NAME"),
   hostname: System.get_env("DB_HOST"),
   pool_size: 10,
   ssl: true,
   ssl_opts: [
     versions: [:"tlsv1.2"]
   ]

config :veil,
    FicdbWeb.Veil.Mailer,
    adapter: Swoosh.Adapters.Sendgrid,
    api_key: "${SEND_GRID_API_KEY}"

config :arc,
       storage: Arc.Storage.GCS,
       bucket: "ficdb.com"

# Do not print debug messages in production
config :logger, level: :info

config :goth,
       json: "{\"type\": \"#{System.get_env("type")}\", \"project_id\": \"#{System.get_env("project_id")}\", \"private_key_id\": \"#{System.get_env("private_key_id")}\", \"private_key\": \"#{System.get_env("private_key")}\",\"client_email\": \"#{System.get_env("client_email")}\", \"client_id\": \"#{System.get_env("client_id")}\", \"auth_uri\": \"#{System.get_env("auth_uri")}\", \"token_uri\": \"#{System.get_env("token_uri")}\", \"auth_provider_x509_cert_url\": \"#{System.get_env("auth_provider_x509_cert_url")}\", \"client_x509_cert_url\": \"#{System.get_env("client_x509_cert_url")}\"}"

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :ficdb, FicdbWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :ficdb, FicdbWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :ficdb, FicdbWeb.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
