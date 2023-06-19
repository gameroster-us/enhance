#!/usr/bin/env bash
# exit on error
set -o errexit

gem install bundler -v '2.0.0.pre.3'
bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate