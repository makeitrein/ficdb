use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"aMKFOqxXiYiC!NQ2F.64b*4b*uW@qVdc]]*0hfw^uJ0xI*:3ZGYdOy`fns^PYE1a"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"_RTtBG~8p~)9C9QeuWy&`pwgg`[k/;A|PoGBc]==`:|AxT}_%[8lC)k2jwx5e].w"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :ficdb do
  set version: current_version(:ficdb)
end

