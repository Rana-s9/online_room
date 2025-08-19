#!/bin/bash
set -x  # ← 各コマンドを実行前に表示
exec > >(tee -a /rails/log/cron.log) 2>&1

export RAILS_ENV=production
export PATH=/usr/local/bundle/bin:$PATH

cd /rails || exit 1
echo ">>> Current directory: $(pwd)"
echo ">>> Whoami: $(whoami)"

bundle exec rake google_events:delete_old
echo ">>> Done at $(date)"
