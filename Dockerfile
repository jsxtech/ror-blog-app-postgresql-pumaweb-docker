FROM ruby:3.2-slim

# Runtime + build dependencies. build-essential and libpq-dev are needed to
# compile native gems (pg, puma); libpq5 is the runtime lib for PostgreSQL.
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems without development/test groups for a lean production image.
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_PATH=/usr/local/bundle

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf /usr/local/bundle/cache

COPY . .

# Run as an unprivileged user rather than root.
RUN useradd --create-home --shell /usr/sbin/nologin app && \
    chown -R app:app /app
USER app

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
