use Mix.Config

config :emoncms,
  host: "https://emoncms.org",
  api_key: {:system, "EMONCMS_API_KEY"}

import_config "#{Mix.env()}.exs"
