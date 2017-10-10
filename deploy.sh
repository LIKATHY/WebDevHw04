#!/bin/bash
# Attribute to part of Professor Nathaniel Tuck's class notes and code

export PORT=4000

printf "Usage: ./deploy.sh <path>\n"

mix ecto.migrate
mix deps.get
cd assets;
npm install
./node_modules/brunch/bin/brunch b -p
cd ..
mix phx.digest
mix release.init

mix release --env=prod
env PORT=4000 _build/prod/rel/microblog/bin/microblog restart
