# memory stores and get/set API
redisStore        = require './satellite/stores/redis'
defaultStore      = require './satellite/stores/default'
clusterHubStore   = require './satellite/stores/clusterHub'

@store = defaultStore

# Load the various strategies
roundRobin        = require './satellite/strategies/roundRobin'
stickySession     = require './satellite/strategies/stickySession'

# Add an address to the list
exports.addAddress = (address, cb) =>
  @store.addresses.get (addresses) =>
    if addresses.indexOf(address) is -1
      @store.addresses.add address, (status) ->
        cb status
    else
      cb 'already there'

# Remove an address from the list
exports.removeAddress = (address, cb) =>
  @store.addresses.remove address, (status) =>
    @store.stickySessions.get (stickySessions) =>
      for cookie, addr of stickySessions
        if addr is address
          @store.stickySessions.delete cookie, (res) ->
            {}
      cb status
  
# Change store
exports.useStore = (storeName, options=null, cb=null) =>
  switch storeName
    when 'default'
      @store = defaultStore
      cb("Ok") if cb?
    when 'redis'
      @store = redisStore
      @store.redisClient = options
      cb("Ok") if cb?
    when 'clusterhub'
      @store = clusterHubStore
      @store.client = options
      cb("Ok") if cb?
    else
      cb("Error: #{storeName} not a valid store type") if cb?

# Make middleware functions available 
exports.roundRobinStrategy = roundRobin.strategy
exports.stickySessionStrategy = stickySession.strategy