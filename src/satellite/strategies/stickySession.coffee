satellite = require '../../satellite'

# Sets a random address in the list as the target address
setRandomTargetAddress = =>
  randomIndex    = Math.floor Math.random() * satellite.store.addresses.getSync().length
  satellite.store.targetAddressSync satellite.store.addresses.getSync()[randomIndex]

# the connect middleware to distribute requests with sticky session ids
# to specific addresses
exports.strategy = (req, res, next) =>
  if req.headers.cookie?
    if satellite.store.stickySessions.getSync(req.headers.cookie)?
      satellite.store.targetAddressSync satellite.store.stickySessions.getSync req.headers.cookie
    else
      satellite.store.stickySessions.setSync req.headers.cookie, setRandomTargetAddress()
  else
    setRandomTargetAddress()
  next()