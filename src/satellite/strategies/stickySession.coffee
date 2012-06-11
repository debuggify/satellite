satellite = require '../../satellite'

# Sets a random address in the list as the target address
setRandomTargetAddress = (cb=null) =>
  satellite.store.addresses.get (addresses) ->
    randomIndex    = Math.floor Math.random() * addresses.length
    satellite.store.targetAddress.set addresses[randomIndex], (res) -> 
      cb() if cb?

# the connect middleware to distribute requests with sticky session ids
# to specific addresses
# TODO - parse the cookie for a specific key i.e. JSESSIONID
exports.strategy = (req, res, next) =>
  if req.headers.cookie?
    satellite.store.stickySessions.get req.headers.cookie, (result) ->
      if result?
        satellite.store.targetAddress.set result, (res) ->
          next()
      else
        setRandomTargetAddress ->
          satellite.store.targetAddress.get (address) ->
            satellite.store.stickySessions.set req.headers.cookie, address, (status) ->
              next()
  else
    setRandomTargetAddress -> next()