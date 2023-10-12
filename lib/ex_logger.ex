defmodule ExLogger do

  @behaviour :gen_event

  alias PubSub

  def init(__MODULE__) do
    {:ok, configure([])}
  end

  defp configure(opts) do
    state = %{level: nil, publisher_node: nil, subscriber_node: nil, topic: nil}
    configure(opts, state)
  end


  defp configure(opts, state) do
    env = Application.get_env(:logger, __MODULE__, [])
    opts = Keyword.merge(env, opts)
    Application.put_env(:logger, __MODULE__, opts)

    level = Keyword.get(opts, :level)
    publisher_node = Keyword.get(opts, :publisher_node)
    subscriber_node = Keyword.get(opts, :subscriber_node)
    topic = Keyword.get(opts, :topic)

    %{state | level: level, publisher_node: publisher_node, subscriber_node: subscriber_node, topic: topic}
  end

  def handle_call({:configure, opts}, state) do
    {:ok, {:ok, configure(opts, state), configure(opts, state)}}
  end

  def handle_event({_level, gl, {Logger, _, _, _}}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, {Logger, msg, timestamps, _details}}, %{level: log_level} = state) do
    if meet_level?(level, log_level) do
      subscribe_to_topic()
      publish_to_topic(level, msg, timestamps, state)

    end

    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  defp meet_level?(_lvl, nil), do: true

  defp meet_level?(lvl, min) do
    Logger.compare_levels(lvl, min) != :lt
  end


  defp publish_to_topic(_level, message, _timestamps, %{publisher_node: _publisher_node} = _state) do
    message = flatten_message(message) |> Enum.join("\n")
    PubSub.publish(:logs, message)
  end

  defp subscribe_to_topic() do
    PubSub.start_link()
    PubSub.subscribe(:global.whereis_name(:client), :logs)
  end

  defp flatten_message(msg) do
    case msg do
      [n | body] -> ["#{n}: #{body}"]
      _ -> [msg]
    end
  end
end
