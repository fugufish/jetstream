defmodule PullBasedConsumerTest do
  use ExUnit.Case
  doctest PullBasedConsumer

  test "greets the world" do
    assert PullBasedConsumer.hello() == :world
  end
end
