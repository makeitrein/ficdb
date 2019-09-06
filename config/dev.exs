use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :ficdb, FicdbWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :ficdb, FicdbWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/ficdb_web/views/.*(ex)$},
      ~r{lib/ficdb_web/templates/.*(eex|drab)$}
    ]
  ]

config :veil,
     FicdbWeb.Veil.Mailer,
     adapter: Swoosh.Adapters.Sendgrid,
     api_key: System.get_env("SEND_GRID_API_KEY")

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
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

config :goth,
       json: "{\"type\": \"#{System.get_env("type")}\", \"project_id\": \"#{System.get_env("project_id")}\", \"private_key_id\": \"#{System.get_env("private_key_id")}\", \"private_key\": \"#{System.get_env("private_key")}\",\"client_email\": \"#{System.get_env("client_email")}\", \"client_id\": \"#{System.get_env("client_id")}\", \"auth_uri\": \"#{System.get_env("auth_uri")}\", \"token_uri\": \"#{System.get_env("token_uri")}\", \"auth_provider_x509_cert_url\": \"#{System.get_env("auth_provider_x509_cert_url")}\", \"client_x509_cert_url\": \"#{System.get_env("client_x509_cert_url")}\"}"