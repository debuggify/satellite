# Basic in-process memory store and get/set API
@store            = require './satellite/stores/default'

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
  
# Make middleware functions available 
exports.roundRobinStrategy = roundRobin.strategy
exports.stickySessionStrategy = stickySession.strategy