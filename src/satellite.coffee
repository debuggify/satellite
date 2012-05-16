# Basic in-process memory store and get/set API
@store            = require './satellite/stores/default'

# Load the various strategies
roundRobin        = require './satellite/strategies/roundRobin'
stickySession     = require './satellite/strategies/stickySession'

# Add an address to the list
exports.addAddress = (address) =>
  index = @store.addresses.get().indexOf address
  @store.addresses.add address if index is -1

# Remove an address from the list
exports.removeAddress = (address) =>
  @store.addresses.remove address
  for cookie, addr of @store.stickySessions.get()
    @store.stickySessions.delete cookie if addr is address

# Make middleware functions available 
exports.roundRobinStrategy = roundRobin.strategy
exports.stickySessionStrategy = stickySession.strategy