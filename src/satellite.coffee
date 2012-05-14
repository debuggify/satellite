# This stores the addresses that we want to proxy requests to 
@addresses = []

# The address to handle the proxy request
@targetAddress = null

# Used by the round-robin strategy to pick which address should 
# handle the request
@targetAddressIndex = 0

# Add an address to the list
exports.addAddress = (address) ->
  index = @addresses.indexOf address
  @addresses.push address if index is -1

# Remove an address from the list
exports.removeAddress = (address) ->
  index = @addresses.indexOf address
  @addresses.splice index, 1

# the connect middleware to distribute requests in a round-robin fashion
exports.roundRobinStrategy = (req, res, next) =>
  @targetAddress = @addresses[@targetAddressIndex]
  if @targetAddressIndex is @addresses.length-1
    @targetAddressIndex = 0
  else 
    @targetAddressIndex += 1
  next()