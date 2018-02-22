FROM ruby:2.5.0-alpine3.7

RUN apk add --update \
  build-base \
  sqlite-dev \
  nodejs \
  tzdata \
  && rm -rf /var/cache/apk/*

RUN gem install bundler

WORKDIR /reddit
COPY Gemfile* /reddit/
RUN bundle install

WORKDIR /reddit
COPY . /reddit/

CMD /bin/sh -c "rm -f /myapp/tmp/pids/server.pid && ./bin/rails db:migrate && ./bin/rails server -b 0.0.0.0 -p 3000"

###################################
# Instructions for AWS alpine 3.7 #
###################################
# !! scp without /vendor /.git /tmp
# apk add --update
#   \ build-base
#   \ libc-dev
#   \ libffi-dev
#   \ libstdc++
#   \ nodejs
#   \ openssl-dev
#   \ paxctl
#   \ ruby
#   \ ruby-dev
#   \ ruby-irb
#   \ ruby-rake
#   \ ruby-bigdecimal
#   \ ruby-io-console
#   \ sqlite-dev
#   \ tzdata

# echo "gem 'json'" >> Gemfile
# gem install bundler
# bundle install
# paxctl -cm $(command -v ruby)
# paxctl -v $(command -v ruby)
# sudo rails server -p 80 -b 0.0.0.0
