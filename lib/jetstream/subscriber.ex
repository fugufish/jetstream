defmodule Jetstream.Subscriber do
  def __using__(_) do
    quote do
      @behaviour Jetstream.Subscriber
    end
  end

  @callback subscribe(stream :: String.t(), topic :: String.t()) :: :ok
end
