defmodule PubSubDistributed do

  require Logger
  @moduledoc """
  Documentation for `PubSubDistributed`.
  """
    def start() do
      pid = spawn(fn -> loop() end)
      name_pid(pid)
    end

    defp name_pid(pid) do
      :global.register_name(:client, pid)
    end

    def loop() do
      receive do
        message ->
          IO.puts "I received `#{message}`"
          loop()
      end
    end

    def generate() do
      Logger.error("Hello Im Back!!!!")
    end
end
