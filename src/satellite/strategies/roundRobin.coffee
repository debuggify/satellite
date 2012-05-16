satellite = require '../../satellite.coffee'

# Used by the round-robin strategy to pick which address should 
# handle the request
@targetAddressIndex = 0

# the connect middleware to distribute requests in a round-robin fashion
@strategy = (req, res, next) =>
  satellite.targetAddress = satellite.addresses[@targetAddressIndex] # GETTER & SETTER
  if @targetAddressIndex is satellite.addresses.length-1 # GETTER
    @targetAddressIndex = 0 # SETTER
  else 
    @targetAddressIndex += 1 # SETTER
  next()