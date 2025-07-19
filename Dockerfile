# Use Elixir 1.15 Alpine image
FROM elixir:1.15-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm

# Set environment variables
ENV MIX_ENV=prod

# Create app directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force --if-missing && \
    mix local.rebar --force --if-missing

# Copy mix files
COPY mix.exs mix.lock ./

# Install dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

# Copy assets
COPY assets assets
COPY priv priv

# Copy source code
COPY lib lib
COPY config config

# Install assets dependencies and build assets
RUN mix assets.setup
RUN mix assets.deploy

# Compile the release
RUN mix compile
RUN mix phx.digest

# Build the release
RUN mix release

# Runtime stage
FROM alpine:3.18 AS runner

# Install runtime dependencies
RUN apk add --no-cache \
    openssl \
    ncurses-libs \
    libstdc++

# Create app user
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

# Create app directory
WORKDIR /app

# Copy the release from builder stage
COPY --from=builder --chown=app:app /app/_build/prod/rel/hello ./

# Create data directory for SQLite database
RUN mkdir -p /app/data && chown -R app:app /app/data

# Switch to app user
USER app

# Expose port
EXPOSE 4000

# Set environment variables
ENV MIX_ENV=prod
ENV PORT=4000
ENV PHX_SERVER=true

# Start the application
CMD ["./bin/hello", "start"]