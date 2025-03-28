My Elixir + Phoenix homepage.

This is a monorepo of a few various services I've written over the years.

# Architecture

When I created this I was very interested in React and GraphQL, so the elixir
app uses absinthe to serve graphql to a react frontend. Nowadays I think this
is very complicated and not worth the extra complexity, but I keep it around so
I have a place to try out react things when I feel like doing that.

## Backend

The elixir side of things is umbrella app, though I think when I created this I
misused that a bit, so recently I've been trying to put everything in the
Client app. Maybe eventually I'll remove the umbrella stuff.

While much of the frontend uses react, there are also several places where I
use phoenix liveview.

## Frontend

A mostly vanilla react app, using urql to consume the graphql API. I've made
some efforts to keep this up tp modern react standards, though there is a lot
of old stuff in places I don't update or use frequently.

# Setup

1. Install asdf and run `asdf install`
1. Setup frontend
    1. In a new terminal: `cd apps/client/assets`
    2. `corepack enable`
    3. `yarn`
3. Setup backend
    1. `mix deps.get`
4. Start the server: `ies -S mix phx.server`

# Deployment

I'm using kamal to manage deployments, so that's why there's a bit of ruby
stuff here and there. I like its simplicity.

# Secret management

Production secrets are encrypted and stored in `secrets.txt.encrypted`.

To access these, you need to write the secret to `key.txt`. This can be found
stored as `Secret key` in the Homepage 1Password vault.

Once you have the `key.txt`, you can decrypt secrets with
`./bin/decrypt_secrets.sh` and re-encrypt them with `./bin/encrypt_secrets.sh`.
