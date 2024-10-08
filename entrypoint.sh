#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /sample-app/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
bundle install
yarn install
yarn build:css
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
exec "$@"