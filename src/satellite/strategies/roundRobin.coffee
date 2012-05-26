satellite = require '../../satellite'

# the connect middleware to distribute requests in a round-robin fashion
exports.strategy = (req, res, next) ->
  satellite.store.targetAddressSync satellite.store.addresses.getSync()[satellite.store.targetAddressIndex.getSync()]
  if satellite.store.targetAddressIndex.getSync() is satellite.store.addresses.getSync().length-1
    satellite.store.targetAddressIndex.resetSync()
  else
    satellite.store.targetAddressIndex.incrementSync()
  next()