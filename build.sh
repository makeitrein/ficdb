#!/usr/bin/env bash
# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
brunch build --production
MIX_ENV=prod mix phx.digest

# Remove the existing release directory and build the release
rm -rf "_build"
MIX_ENV=prod mix release
