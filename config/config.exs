import Config

File.ls!("../apps")
|> Enum.each(fn app ->
  import_config("../apps/#{app}/config/config.exs")
end)
