defmodule Ficdb.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ficdb,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Ficdb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.4"},
      {:postgrex, "~> 0.14.0-rc.0", override: true},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      ## CUSTOM DEPS ##
      {:veil, "~> 0.1"},
      {:breadcrumble, "~> 1.0.0"},
      {:timex, "~> 3.1"},
      {:quantum, "~> 2.3"},
      {:clipboard, ">= 0.0.0", only: [:dev]},

                                    {:arc, "~> 0.10.0"},
      {:arc_ecto, "~> 0.10.0"},
      {:phoenix_active_link, "~> 0.1.1"},
      {:ecto_enum, "~> 1.0"},
      {:floki, "~> 0.20.0"},
      {:httpoison, "~> 1.0", override: true},
      {:inflex, "~> 1.10.0" },
      {:rummage_ecto, "~> 2.0.0-rc.0"},
      {:poison, "~> 3.1"},
      {:filterable, "~> 0.6.0"},
      {:distillery, "~> 2.0.12"},
      {:arc_gcs, "~> 0.0.5"},
      {:goth, "~> 0.9.0"},
      {:ecto, github: "elixir-ecto/ecto", override: true},
      {:ecto_sql, github: "elixir-ecto/ecto_sql", override: true},

    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
