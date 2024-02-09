const amqplib = require('amqplib');
const WebSocket = require('ws');
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

    // Create WebSocket server
    const wss = new WebSocket.Server({ noServer: true });

    // Function to generate and publish a random number every second
    async function sendMessage() {
        const randomNumber = Math.floor(Math.random() * 100);
        const msg = randomNumber.toString();
        console.log("Generated message:", msg); // Print the generated message to the terminal

        // Broadcast message to WebSocket clients
        wss.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(msg);
            }
        });

        await ch.publish(exch, rkey, Buffer.from(msg));
        setTimeout(sendMessage, 5000); // Call the function again after 5 seconds
    }

    // Start sending messages
    sendMessage(); // Initial call to start sending messages

    return wss;
}

// Create HTTP server
const server = http.createServer();
const wssPromise = produce();

server.on('upgrade', (request, socket, head) => {
    wssPromise.then(wss => {
        wss.handleUpgrade(request, socket, head, ws => {
            wss.emit('connection', ws, request);
        });
    }).catch(console.error);
});

server.listen(8080, () => {
    console.log('Server running at http://localhost:8080/');
});
