# Basic in-process memory store and get/set API
@store            = require './satellite/stores/default'

# Load the various strategies
roundRobin        = require './satellite/strategies/roundRobin'
stickySession     = require './satellite/strategies/stickySession'

# Add an address to the list, sync
exports.addAddressSync = (address) =>
  index = @store.addresses.getSync().indexOf address
  @store.addresses.addSync address if index is -1

# Remove an address from the list, sync
exports.removeAddressSync = (address) =>
  @store.addresses.removeSync address
  for cookie, addr of @store.stickySessions.getSync()
    @store.stickySessions.deleteSync cookie if addr is address

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
    cb status
#   for cookie, addr of @store.stickySessions.getSync()
#     @store.stickySessions.deleteSync cookie if addr is address

  
# Make middleware functions available 
exports.roundRobinStrategy = roundRobin.strategy
exports.stickySessionStrategy = stickySession.strategy