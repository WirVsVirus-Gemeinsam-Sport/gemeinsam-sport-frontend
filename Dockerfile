FROM bitwalker/alpine-elixir-phoenix:1.9.4

ADD ./ /app
WORKDIR /app
ENV MIX_ENV=prod 
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile
RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest
CMD mix phx.server
