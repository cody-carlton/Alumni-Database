// #region ***** Libraries
// Require the Fastify framework and instantiate it
const fastify = require("fastify")();
// #endregion

// #region ***** Server Routes
// Define a simple default GET route
fastify.get("/", (request, reply) => {
  reply.send("Hello World!");
});
// Define "alien" GET route
fastify.get("/alien", (request, reply) => {
  reply.send("Hello from an Alien World");
});
// #endregion

// #region ***** Start HTTP Server ****
// Start server and listen to requests using Fastify
// Note: Latest version of fastify listen requires object as first parameter
const host = "localhost";
const port = 8080;
console.log("Starting HTTP server...");
fastify.listen({ host, port }, (err, address) => {
  if (err) {
    console.log(err);
    process.exit(1);
  }
  console.log(`Server listening on ${address}`);
});
// #endregion
