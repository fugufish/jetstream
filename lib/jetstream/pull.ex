defmodule Jetstream.PullConsumer do
  @callback init(state :: list()) ::
              {:ok, state :: list()}
              | {:ok, state :: list(), timeout() | :hibernate | {:continue, term()}}
              | :ignore
              | {:stop, reason :: any()}

  defmacro __using__(_) do
    quote do
      use GenServer

      @behaviour Jetstream.PullConsumer

      def start_link(_, opts \\ []) do
        GenServer.start_link(__MODULE__, [], opts)
      end

      def subscribe(stream, topic) do
        send(self(), {:sub, stream, topic, "_CON.#{Jetstream.Util.nuid()}"})
        :ok
      end

      def ack_next(message) do
        send(self(), {:ack, message})
      end

      def handle_info({:sub, stream, topic, listening_topic}, state) do
        next_state = state ++ [stream: stream, topic: topic, listening_topic: listening_topic]

        {:ok, _sid} = Gnat.sub(GnatConnection, self(), listening_topic)

        :ok =
          Gnat.pub(GnatConnection, "$JS.API.CONSUMER.MSG.NEXT.#{stream}.#{topic}", "1",
            reply_to: listening_topic
          )

        {:noreply, state}
      end

      def handle_info({:msg, message}, state) do
        apply(self(), :handle_info, [message])
        ack_next(message)

        {:noreply, state}
      end

      def handle_info({:ack, message}, state) do
        Gnat.pub(GnatConnection, message.reply_to, "+NXT", reply_to: state.listening_topic)

        {:noreply, state}
      end
    end
  end
end
