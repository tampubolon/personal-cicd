# Backend Service A

This service is written in Javascript (nodeJS).
This service  continuously generate a random number less then 100 and publish it RabbitMQ broker.
RabbitMQ broker is publicly accessible from: octopus.rmq3.cloudamqp.com 

This service also creates a WebSocket server.
The WebSocket clients can then receive and display these random numbers in real-time.
You can open `index.html` file in this folder on your local as the Websocket clients.