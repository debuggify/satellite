Satellite
=========

Extensions for Nodejitsu's node-http-proxy library.

What is it for?
---

Satellite uses Nodejitsu's [node-http-proxy](https://github.com/nodejitsu/node-http-proxy) to help with:

- Load-balancing requests across multiple servers via a round-robin strategy.
- Running the proxy server over multiple CPU cores using Node.js' cluster API.
- Being able to add or remove servers from the proxy list on-the-fly.
- Supporting sticky sessions by routing requests to specific servers.

Installation
---

    npm install satellite

Usage (round-robin)
---

Let's say you have an application which has multiple instances running on different servers, 
and you want to setup a proxy server to load-balance requests across those servers. 

Satellite provides a round-robin strategy that you can apply to your existing proxy server code:


```javascript
    // This example demonstrates proxying requests between
    // 2 servers
    var httpProxy   = require('http-proxy');
    var satellite   = require('satellite');

    // Add 2 different servers to the proxy list
    satellite.addAddress({host: '111.11.111.111', port: 80});
    satellite.addAddress({host: '222.22.222.222', port: 80});

    var proxyServer = httpProxy.createServer(

      // tell the proxy serve to use a connect-compatible 
      // middleware that provides round-robin support.
      satellite.roundRobinStrategy,

      function (req,res, proxy){

        // tell proxyRequest to use the target address
        // determined by satellite, which will be one
        // of the 2 servers.
        proxy.proxyRequest(req, res, satellite.targetAddress);
      }
    ).listen(80);
```

Your proxy server will now distribute requests to the servers in a round-robin fashion.

Usage (sticky-session support)
---

Some application setups require sticky-session support. 

For more info on sticky sessions and why you would use them, 
see the explanation provided in the Readme on [SockJS' github repository](https://github.com/sockjs/sockjs-node#sticky-sessions).

To enable sticky session support in your proxy server, you can do this:

```javascript
    // This example demonstrates using sticky session
    // support
    var httpProxy   = require('http-proxy');
    var satellite   = require('satellite');

    // Add 2 different servers to the proxy list
    satellite.addAddress({host: '111.11.111.111', port: 80});
    satellite.addAddress({host: '222.22.222.222', port: 80});

    var proxyServer = httpProxy.createServer(

      // tell the proxy server to use sticky-session support. 
      satellite.stickySessionStrategy,

      function (req,res, proxy){
        proxy.proxyRequest(req, res, satellite.targetAddress);
      }
    ).listen(80);
```

**NOTE:** If you wish to use both round-robin and sticky-session support 
in your application, make sure that you call the sticky-session middleware
after you have called the round-robin middleware, like this:

```javascript
    var proxyServer = httpProxy.createServer(
      satellite.roundRobinStrategy,
      satellite.stickySessionStrategy,
```

Dependencies
---

Satellite was built against Node.js v0.6.17, and has it's engine set against that version.

It may be able to run on previous versions of Node.js, but you'll need to git clone a copy and modify the package.json to do so.