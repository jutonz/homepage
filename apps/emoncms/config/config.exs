import Config

config :emoncms,
  host: "https://emoncms.org",
  api_key: System.get_env("EMONCMS_API_KEY")

import_config "#{Mix.env()}.exs"
