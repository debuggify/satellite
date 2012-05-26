# Basic in-process memory store and get/set API
@store            = require './satellite/stores/default'

# Load the various strategies
roundRobin        = require './satellite/strategies/roundRobin'
stickySession     = require './satellite/strategies/stickySession'

# Add an address to the list
exports.addAddressSync = (address) =>
  index = @store.addresses.getSync().indexOf address
  @store.addresses.addSync address if index is -1

# Remove an address from the list
exports.removeAddressSync = (address) =>
  @store.addresses.removeSync address
  for cookie, addr of @store.stickySessions.getSync()
    @store.stickySessions.deleteSync cookie if addr is address

# Make middleware functions available 
exports.roundRobinStrategy = roundRobin.strategy
exports.stickySessionStrategy = stickySession.strategy