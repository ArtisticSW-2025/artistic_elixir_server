# Dockerfile for Elixir Bandit Websocket Server
FROM elixir:1.15-alpine AS build

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache build-base git

# Copy mix files and install dependencies
COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get --only prod

# Copy the rest of the app
COPY . .

# Compile the project
RUN MIX_ENV=prod mix compile

# Build release
RUN MIX_ENV=prod mix release

# Start a new, smaller image for running
FROM alpine:3.18 AS app
WORKDIR /app
RUN apk add --no-cache libstdc++ openssl ncurses-libs

COPY --from=build /app/_build/prod/rel/artistic_elixir /app

ENV LANG=en_US.UTF-8
ENV MIX_ENV=prod

EXPOSE 4000

CMD ["/app/bin/artistic_elixir", "start"]
