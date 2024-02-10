const amqplib = require('amqplib');
const http = require('http');

const amqp_url = process.env.CLOUDAMQP_URL || 'amqps://lfacpsmx:UrFwEeZVBOUOXDHCTKffS3if-QBBbbFT@octopus.rmq3.cloudamqp.com/lfacpsmx';

async function produce() {
    console.log("Publishing");
    const conn = await amqplib.connect(amqp_url, "heartbeat=60");
    const ch = await conn.createChannel()
    const exch = 'pintu-exchange';
    const q = 'pintu-queue';
    const rkey = 'test_route';

    await ch.assertExchange(exch, 'direct', { durable: true }).catch(console.error);
    await ch.assertQueue(q, { durable: true });
    await ch.bindQueue(q, exch, rkey);

    // Create HTTP server
    const server = http.createServer();

    server.on('request', (req, res) => {
        if (req.url === '/messages') {
            // Set headers to enable CORS (Cross-Origin Resource Sharing)
            res.setHeader('Access-Control-Allow-Origin', '*');
            res.setHeader('Access-Control-Request-Method', '*');
            res.setHeader('Access-Control-Allow-Methods', 'OPTIONS, GET');
            res.setHeader('Access-Control-Allow-Headers', '*');

            // Set response headers
            res.writeHead(200, {
                'Content-Type': 'text/event-stream',
                'Cache-Control': 'no-cache',
                'Connection': 'keep-alive',
            });

            // Function to generate and send a random number every second
            function sendMessage() {
                const randomNumber = Math.floor(Math.random() * 100);
                const msg = randomNumber.toString();
                console.log("Generate random number and publish to RabbitMQ:", msg); // Print the generated message to the terminal

                // Send message to RabbitMQ
                ch.publish(exch, rkey, Buffer.from(msg));

                // Send message to browser
                res.write(`Generate random number and publish to RabbitMQ: ${msg}\n\n`); // Send the message as a server-sent event

                setTimeout(sendMessage, 5000); // Call the function again after 5 seconds
            }

            // Start sending messages
            sendMessage(); // Initial call to start sending messages

            // Handle client disconnect
            req.on('close', () => {
                console.log('Client disconnected');
                res.end(); // End response when client disconnects
            });
        }
    });

    server.listen(8080, () => {
        console.log('Server running at http://localhost:8080/');
    });
}

produce();