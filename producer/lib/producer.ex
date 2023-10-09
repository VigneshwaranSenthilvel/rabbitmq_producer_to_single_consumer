defmodule Producer do
  use GenServer

  @queue_name "my_simple_queue"

  def create_channel do
    {:ok, connection} = AMQP.Connection.open()
    IO.inspect("Connection Established Between Producer and RabbitMQ")
    {:ok, channel} = AMQP.Channel.open(connection)
    IO.inspect("Channel Created for Producer")
    AMQP.Queue.declare(channel, @queue_name)
    IO.inspect("Queue Created for Producer")
    {connection, channel}
  end

  def init(_opts) do
    IO.inspect("Producer GenServer Started...")
    {:ok, create_channel()}
  end

  def handle_call({:get, pid}, _from, state) do
    Process.monitor(pid)
    {_connection, channel} = state
    {:reply, channel, state}
  end

  def handle_cast({:add, message}, state) do
    {_connection, channel} = state
    AMQP.Basic.publish(channel, "", @queue_name, message)
    IO.inspect("Message pushed into queue")
    {:noreply, state}
  end

  def handle_info({:DOWN, _, :process, _pid, _}, state) do
    {connection, _channel} = state
    AMQP.Connection.close(connection)
    {:noreply, state}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def channel? do
    GenServer.call(__MODULE__, {:get, self()})
  end

  def add(message) do
    GenServer.cast(__MODULE__, {:add, message})
  end
end
