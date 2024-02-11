# Backend Service B

This service is written in Golang.
This service  continuously consume message from a RabbitMQ broker.
RabbitMQ broker is publicly accessible from: octopus.rmq3.cloudamqp.com 

This service compute factorial of the integer number consumed from the RabbitMQ broker.
This service is publicly accessible from: