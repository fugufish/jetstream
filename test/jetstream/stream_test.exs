defmodule Jetstream.StreamTest do
  alias Jetstream.Stream

  use ExUnit.Case

  setup do
    {:ok, stream: %Stream{name: "LIST_TEST", subjects: ["STREAM TEST"]}}
  end

  describe "create" do
    test "creates a stream", context do
      {:ok, response} = Stream.create(context.stream)
      assert response.config == context.stream

      assert response.state == %{
               bytes: 0,
               consumer_count: 0,
               first_seq: 0,
               first_ts: ~U[0001-01-01 00:00:00Z],
               last_seq: 0,
               last_ts: ~U[0001-01-01 00:00:00Z],
               messages: 0
             }
    end
  end

  describe "list" do
    test "lists streams", context do
      {:ok, response} = Stream.create(context.stream)
      {:ok, %{streams: streams}} = Stream.list()
      assert "LIST_TEST" in streams
    end
  end

  describe "delete" do
    test "that it delets the streams", context do
      {:ok, _response} = Stream.create(context.stream)
      assert :ok = Stream.delete("LIST_TEST")
      {:ok, %{streams: streams}} = Stream.list()
      assert streams == nil || !("LIST_TEST" in streams)
    end
  end

  describe "info" do
    stream = %Stream{name: "INFO_TEST", subjects: ["INFO_TEST.*"]}
    assert {:ok, _response} = Stream.create(stream)

    assert {:ok, response} = Stream.info("INFO_TEST")
    assert response.config == stream

    assert response.state == %{
             bytes: 0,
             consumer_count: 0,
             first_seq: 0,
             first_ts: ~U[0001-01-01 00:00:00Z],
             last_seq: 0,
             last_ts: ~U[0001-01-01 00:00:00Z],
             messages: 0
           }
  end
end
