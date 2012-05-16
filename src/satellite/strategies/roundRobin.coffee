satellite = require '../../satellite'

# Used by the round-robin strategy to pick which address should 
# handle the request
#@targetAddressIndex = 0

# the connect middleware to distribute requests in a round-robin fashion
exports.strategy = (req, res, next) ->
  satellite.store.targetAddress satellite.store.addresses.get()[satellite.store.targetAddressIndex.get()]
  if satellite.store.targetAddressIndex.get() is satellite.store.addresses.get().length-1
    satellite.store.targetAddressIndex.reset()
  else
    satellite.store.targetAddressIndex.increment()
  next()