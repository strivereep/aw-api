ARG RUBY_VERSION=3.1.2

FROM ruby:$RUBY_VERSION-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential libpq-dev postgresql-client curl && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN gem install bundler -v 2.4.19

WORKDIR /app

RUN bundle config set --local path 'usr/local/bundle' && \
  bundle config set --local without 'development test'

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 4 --retry 3

COPY config/database.yml ./config/

COPY . ./

COPY entrypoints/docker-entrypoint.sh /app/entrypoints/docker-entrypoint.sh
RUN chmod +x /app/entrypoints/docker-entrypoint.sh

ENTRYPOINT [ "/app/entrypoints/docker-entrypoint.sh" ]

EXPOSE 3000

# The default Rails Dockerfile uses `./bin/rails server`, but when using Puma, 
# they recommend using bundle exec puma. ref: https://github.com/puma/puma#rails
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
