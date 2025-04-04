# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.5
FROM ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# Throw-away build stage
FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    python-is-python3\
    libjemalloc2

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle /usr/local/bundle/ruby/*/cache

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Final image
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libvips \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
