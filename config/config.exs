use Mix.Config

config :logger, backends: ExLogger

config :logger, ExLogger,
  level: :error,
  publisher_node: :"publisher@localhost",
  subscriber_node: :"subscriber@localhost",
  topic: :"elixir"
