// Generated by CoffeeScript 1.3.1
(function() {
  var defaultStore, redisStore, roundRobin, stickySession,
    _this = this;

  redisStore = require('./satellite/stores/redis');

  defaultStore = require('./satellite/stores/default');

  this.store = defaultStore;

  roundRobin = require('./satellite/strategies/roundRobin');

  stickySession = require('./satellite/strategies/stickySession');

  exports.addAddress = function(address, cb) {
    return _this.store.addresses.get(function(addresses) {
      if (addresses.indexOf(address) === -1) {
        return _this.store.addresses.add(address, function(status) {
          return cb(status);
        });
      } else {
        return cb('already there');
      }
    });
  };

  exports.removeAddress = function(address, cb) {
    return _this.store.addresses.remove(address, function(status) {
      return _this.store.stickySessions.get(function(stickySessions) {
        var addr, cookie;
        for (cookie in stickySessions) {
          addr = stickySessions[cookie];
          if (addr === address) {
            _this.store.stickySessions["delete"](cookie, function(res) {
              return {};
            });
          }
        }
        return cb(status);
      });
    });
  };

  exports.useStore = function(storeName, options, cb) {
    if (options == null) {
      options = {};
    }
    if (cb == null) {
      cb = null;
    }
    switch (storeName) {
      case 'default':
        _this.store = defaultStore;
        if (cb != null) {
          return cb("Ok");
        }
        break;
      case 'redis':
        _this.store = redisStore;
        _this.store.redisClient = options.redisClient;
        _this.store.namespace = options.namespace || 'satellite';
        if (cb != null) {
          return cb("Ok");
        }
        break;
      default:
        if (cb != null) {
          return cb("Error: " + storeName + " not a valid store type");
        }
    }
  };

  exports.roundRobinStrategy = roundRobin.strategy;

  exports.stickySessionStrategy = stickySession.strategy;

}).call(this);
