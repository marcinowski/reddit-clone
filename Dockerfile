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
