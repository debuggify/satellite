
# This stores the addresses that we want to proxy requests to 
@addresses = []

# The address to handle the proxy request
@targetAddress = null

# Used by the round-robin strategy to pick which address should 
# handle the request
@targetAddressIndex = 0

roundRobin      = require './satellite/strategies/roundRobin'
@stickySessions  = require './satellite/strategies/stickySessions'

# Add an address to the list
exports.addAddress = (address) =>
  index = @addresses.indexOf address # GETTER
  @addresses.push address if index is -1 # SETTER

# Remove an address from the list
exports.removeAddress = (address) =>
  index = @addresses.indexOf address # GETTER
  @addresses.splice index, 1 # SETTER
  for cookie, addr of @stickySessions # GETTER
    delete @stickySessions[cookie] if addr is address # SETTER

# the connect middleware to distribute requests in a round-robin fashion
exports.roundRobinStrategy = (req, res, next) =>
  @targetAddress = @addresses[@targetAddressIndex] # GETTER & SETTER
  if @targetAddressIndex is @addresses.length-1 # GETTER
    @targetAddressIndex = 0 # SETTER
  else 
    @targetAddressIndex += 1 # SETTER
  next()

# the connect middleware to distribute requests with sticky session ids
# to specific addresses
exports.stickySessionStrategy = @stickySessions.strategy