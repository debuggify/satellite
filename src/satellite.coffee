
# This stores the addresses that we want to proxy requests to 
@addresses = []

# The address to handle the proxy request
@targetAddress = null

@roundRobin      = require './satellite/strategies/roundRobin'
@stickySessions  = require './satellite/strategies/stickySessions'

# Add an address to the list
exports.addAddress = (address) =>
  index = @addresses.indexOf address # GETTER
  @addresses.push address if index is -1 # SETTER

# Remove an address from the list
exports.removeAddress = (address) =>
  index = @addresses.indexOf address # GETTER
  @addresses.splice index, 1 # SETTER
  for cookie, addr of @stickySessions.sessions # GETTER
    delete @stickySessions.sessions[cookie] if addr is address # SETTER

exports.stickySessionStrategy = @stickySessions.strategy
exports.roundRobinStrategy    = @roundRobin.strategy