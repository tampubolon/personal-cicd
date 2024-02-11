# Backend Service B

This service is written in Golang.
This service continuously consume message from a RabbitMQ broker.
RabbitMQ broker is publicly accessible from: octopus.rmq3.cloudamqp.com 

This service compute factorial of the integer number consumed from the RabbitMQ broker.
This service is publicly accessible from:
http://k8s-pintugol-martinus-ea50928746-1405819565.ap-southeast-1.elb.amazonaws.com/events