defmodule PubSubDistributedTest do
  use ExUnit.Case
  doctest PubSubDistributed

  test "greets the world" do
    assert PubSubDistributed.hello() == :world
  end
end
