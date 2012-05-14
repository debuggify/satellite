Satellite
=========

Extensions for node-http-proxy

Use case
---

Satellite uses Nodejitsu's [node-http-proxy](https://github.com/nodejitsu/node-http-proxy) and extends it to support these use cases:

- Load-balancing requests across multiple servers via a round-robin strategy.
- Running the proxy server over multiple CPU cores using Node.js' cluster API.
- Being able to add or remove servers from the proxy list on-the-fly.
- Support sticky sessions by routing requests to specific servers.

Installation
---

  npm install satellite

