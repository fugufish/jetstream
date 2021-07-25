defmodule Jetstream.Application do
  @moduledoc false

  def start(_type, _args) do
    connection_config =
      Application.fetch_env!(:jetstream, :connection)
      |> Enum.into(%{})

    children = [
      %{
        id: GnatConnection,
        start: {Gnat, :start_link, [connection_config, [name: GnatConnection]]}
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
