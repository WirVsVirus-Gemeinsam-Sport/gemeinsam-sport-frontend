FROM bitwalker/alpine-elixir-phoenix:1.9.4

ADD ./ /app
WORKDIR /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN MIX_ENV=prod mix compile
RUN npm run deploy --prefix ./assets
RUN mix phx.digest
CMD MIX_ENV=prod mix phx.server
