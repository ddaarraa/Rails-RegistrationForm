# syntax = docker/dockerfile:1

# Define the Ruby version and slim variant for a smaller image
ARG RUBY_VERSION=3.3.1
FROM ruby:$RUBY_VERSION-slim-bullseye as base

# Set environment variables for production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_BIN="/usr/local/bundle/bin" \
    PATH="$BUNDLE_BIN:$PATH"

# Install runtime dependencies and remove cache
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        libvips \
        libsqlite3-0 \
        curl && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Temporary build stage to compile and install gems
FROM base as build

# Install build dependencies needed to install gems and clean up cache
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        pkg-config && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set working directory
WORKDIR /rails

# Copy Gemfile and Gemfile.lock first for efficient Docker layer caching
COPY Gemfile Gemfile.lock ./

# Install gems and clean up after
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy the rest of the application code
COPY . .

# Precompile assets for production with a dummy SECRET_KEY_BASE
RUN SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production ./bin/rails assets:precompile && \
    bundle exec bootsnap precompile app/ lib/

# Final stage for the minimal production image
FROM base

# Install only runtime dependencies (no build tools) and clean up cache
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libsqlite3-0 libvips && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Set working directory and copy the built artifacts (gems, precompiled assets, application)
WORKDIR /rails
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Ensure non-root user for security
RUN useradd -m -s /bin/bash rails && \
    chown -R rails:rails /rails /usr/local/bundle /rails/log /rails/tmp /rails/storage
USER rails:rails

# Entrypoint script to prepare the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose the port that the Rails app will run on
EXPOSE 3000

# Default command to run the Rails server
CMD ["./bin/rails", "server"]
