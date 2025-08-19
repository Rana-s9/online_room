#!/bin/bash
export RAILS_ENV=production
export PATH=/usr/local/bundle/bin:$PATH
cd /rails
bundle exec rake google_events:delete_old >> log/cron.log 2>&1
