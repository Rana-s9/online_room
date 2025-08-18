#!/bin/bash
export RAILS_ENV=production
cd /rails
bundle exec rake google_events:delete_old >> log/cron.log 2>&1
