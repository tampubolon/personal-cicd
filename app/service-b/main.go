package main

import (
	"fmt"
	"log"
	"math/big"
	"os"
	"os/signal"
	"strconv"

	"github.com/streadway/amqp"
)

func failOnError(err error, msg string) {
	if err != nil {
		log.Fatalf("%s: %s", msg, err)
	}
}

// Function to compute factorial of a number
func factorial(n int) *big.Int {
	if n <= 1 {
		return big.NewInt(1)
	}
	return big.NewInt(int64(n)).Mul(factorial(n-1), big.NewInt(int64(n)))
}

func main() {
	// Define RabbitMQ connection URL
	amqpURL := "amqps://lfacpsmx:UrFwEeZVBOUOXDHCTKffS3if-QBBbbFT@octopus.rmq3.cloudamqp.com/lfacpsmx"

	// Connect to RabbitMQ
	conn, err := amqp.Dial(amqpURL)
	failOnError(err, "Failed to connect to RabbitMQ")
	defer conn.Close()

	// Create a channel
	ch, err := conn.Channel()
	failOnError(err, "Failed to open a channel")
	defer ch.Close()

	// Declare the exchange
	exchangeName := "pintu-exchange"
	err = ch.ExchangeDeclare(
		exchangeName, // name
		"direct",     // type
		true,         // durable
		false,        // auto-deleted
		false,        // internal
		false,        // no-wait
		nil,          // arguments
	)
	failOnError(err, "Failed to declare the exchange")

	// Declare the queue
	queueName := "pintu-queue"
	_, err = ch.QueueDeclare(
		queueName, // name
		true,      // durable
		false,     // delete when unused
		false,     // exclusive
		false,     // no-wait
		nil,       // arguments
	)
	failOnError(err, "Failed to declare the queue")

	// Bind the queue to the exchange
	routingKey := "test_route"
	err = ch.QueueBind(
		queueName,    // queue name
		routingKey,   // routing key
		exchangeName, // exchange
		false,
		nil,
	)
	failOnError(err, "Failed to bind the queue")

	// Consume messages from the queue
	msgs, err := ch.Consume(
		queueName, // queue
		"",        // consumer
		true,      // auto-ack
		false,     // exclusive
		false,     // no-local
		false,     // no-wait
		nil,       // args
	)
	failOnError(err, "Failed to register a consumer")

	// Setup interrupt handling for graceful shutdown
	interrupt := make(chan os.Signal, 1)
	signal.Notify(interrupt, os.Interrupt)

	// Start consuming messages
	for {
		select {
		case msg := <-msgs:
			// Parse the received message as an integer
			n, err := strconv.Atoi(string(msg.Body))
			if err != nil {
				log.Printf("Failed to parse message as an integer: %s", err)
				continue
			}
			// Compute the factorial of the received number
			f := factorial(n)
			fmt.Printf("Consume message from RabbitMQ. Factorial of %d is: %s\n", n, f.String())
		case <-interrupt:
			fmt.Println("Interrupt signal received. Closing consumer...")
			return
		}
	}
}