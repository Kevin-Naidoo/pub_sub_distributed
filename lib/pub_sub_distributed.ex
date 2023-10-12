defmodule PubSubDistributed do

  require Logger
  @moduledoc """
  Documentation for `PubSubDistributed`.
  """
    def start() do
      pid = spawn(fn -> loop() end)
      :ets.new(:logs_table, [:duplicate_bag, :public ,:named_table])
      name_pid(pid)
    end

    defp name_pid(pid) do
      :global.register_name(:client, pid)
    end

    def loop() do
      receive do
        message ->
          IO.puts message
          ets_store(message)
          loop()
      end
    end

    defp ets_store(message) do
      :ets.insert_new(:logs_table, {message})
      :ets.match(:logs_table, :"$1")
    end

    def generate() do
      Logger.error("Hello Im !!!!")
    end
end
