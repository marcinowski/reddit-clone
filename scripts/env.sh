# This is for alpine distribution
set -e

sudo apk add --update \
  build-base \
  libc-dev \
  libffi-dev \
  libpq-dev \
  libstdc++ \
  nodejs \
  openssl-dev \
  paxctl \
  ruby \
  ruby-dev \
  ruby-irb \
  ruby-rake \
  ruby-bigdecimal \
  ruby-io-console \
  sqlite-dev \
  tzdata

cd /home/alpine/reddit/
echo "gem 'json'" >> Gemfile
sudo gem install bundler rdoc
sudo bundle install
sudo paxctl -cm $(command -v ruby)
sudo paxctl -v $(command -v ruby)
