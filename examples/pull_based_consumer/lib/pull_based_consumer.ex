defmodule PullBasedConsumer do
  use Jetstream.PullConsumer

  def init(_) do
    subscribe("test", "hello")

    {:ok, []}
  end

  def handle_info(message, _) do
    IO.puts(message.inspect)
    {:noreply, []}
  end
end
