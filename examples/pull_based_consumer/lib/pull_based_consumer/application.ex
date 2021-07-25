defmodule PullBasedConsumer.Application do
  def start(_type, _args) do
    Supervisor.start_link([PullBasedConsumer], strategy: :one_for_one)
  end
end
