defmodule Consumer do
  use GenServer

  @queue_name "my_simple_queue"

  def create_channel do
    {:ok, connection} = AMQP.Connection.open()
    IO.inspect("Connection Established Between Consumer and RabbitMQ")
    {:ok, channel} = AMQP.Channel.open(connection)
    IO.inspect("Channel Created for Consumer")
    AMQP.Queue.declare(channel, @queue_name)
    IO.inspect("Queue Created if not yet created")
    {connection, channel}
  end

  def init(_) do
    {_connection, channel} = create_channel()
    consume(channel)
    {:ok, :watching}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  defp consume(chennal) do
    AMQP.Basic.consume(chennal, @queue_name, nil, no_ack: true)
    wait_for_messages()
  end

  def wait_for_messages do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts(" [x] Received #{payload}")
        wait_for_messages()
    end
  end
end
