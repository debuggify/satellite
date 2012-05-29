satellite = require '../../satellite'

# the connect middleware to distribute requests in a round-robin fashion
exports.strategy = (req, res, next) ->
  satellite.store.addresses.get (addresses) ->
    satellite.store.targetAddressIndex.get (number) ->
      newAddress = addresses[number]
      satellite.store.targetAddress.set newAddress, (res) ->
        if number is addresses.length-1
          satellite.store.targetAddressIndex.reset (res) ->
            next()
        else
          satellite.store.targetAddressIndex.increment (res) ->
            next()