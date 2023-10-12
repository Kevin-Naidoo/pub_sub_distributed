defmodule PubSubDistributed do

  require Logger
  @moduledoc """
  Documentation for `PubSubDistributed`.
  """
    def start(client_name) do
      spawn(fn -> loop(client_name) end)
    end

    def loop(name) do
      receive do
        message ->
          IO.puts "#{name} received `#{message}`"
          loop(name)
      end
    end

    def generate() do
      Logger.error("Hello Im Back!!!!")
    end
end
