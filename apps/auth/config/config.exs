# This file is responsible for configuring your application and its
# dependencies with the aid of the Mix.Config module.
use Mix.Config

secret_key_base = System.get_env("SECRET_KEY_BASE") || "9Z4EOxi6xe+P7ci7gSQn/Lqt4QIXinGJu+CW4YI0lQYaBzFfJsvLvMDm2B38ETM+"

config :auth, Auth.Guardian,
  issuer: "homepage",
  secret_key: secret_key_base
