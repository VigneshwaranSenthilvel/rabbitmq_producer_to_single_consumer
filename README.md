# RabbitMQ With Elixir

Implementing RabbitMQ with one Producer ( Sender ) -> one Consumer ( Receiver )

## Dependencies

- [ASDF](https://asdf-vm.com/guide/getting-started.html)
- [RabbitMQ](https://www.rabbitmq.com/download.html)

## Run Locally

Clone the project

```bash
  git clone https://github.com/VigneshwaranSenthilvel/rabbitmq_producer_to_single_consumer.git
```

Go to the project directory producer and consumer in differemt terminal

```bash
  terminal1: cd rabbitmq_producer_to_single_consumer/producer
  terminal2: cd rabbitmq_producer_to_single_consumer/consumer
```

Install dependencies

```bash
  asdf install
```

Start the server

```bash
  mix deps.get
  iex -S mix
```

## Terminal 1

Send a message to the queue

```bash
  Producer.add("Your Custom Message")
```

## Terminal 2

Receive a message from queue

```bash
  [x] Received Your Custom Message
```
