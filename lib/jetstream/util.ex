defmodule Jetstream.Util do
  @moduledoc """
  Provides unitility functions for working with Nats Jestream
  """

  @doc """
  Returns a NATS unique identifier
  """
  @spec nuid() :: String.t()
  def nuid do
    :crypto.strong_rand_bytes(12) |> Base.encode64()
  end

  @doc """
  Make a request to the Nats server.
  """
  @spec request(topic :: String.t(), payload :: atom()) :: {:ok, Map.t()} | {:error, any}
  def request(topic, payload) do
    with {:ok, %{body: body}} <- Gnat.request(GnatConnection, topic, payload),
         {:ok, decoded} <- Jason.decode(body) do
      case decoded do
        %{"error" => err} ->
          {:error, err}

        other ->
          {:ok, other}
      end
    end
  end

  def to_datetime(nil), do: nil

  def to_datetime(str) do
    {:ok, datetime, _} = DateTime.from_iso8601(str)
    datetime
  end

  def to_sym(nil), do: nil

  def to_sym(str) when is_binary(str) do
    String.to_existing_atom(str)
  end
end
