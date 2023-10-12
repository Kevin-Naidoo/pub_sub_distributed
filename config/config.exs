#use Mix.Config
import Config

config :logger, backends: [:console, ExLogger]

config :logger, ExLogger,
  level: :error,
  publisher_node: :"publisher@localhost",
  subscriber_node: :"subscriber@localhost",
  topic: :elixir
