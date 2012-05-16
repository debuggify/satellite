satellite = require '../../satellite'

  # Sets a random address in the list as the target address
setRandomTargetAddress = =>
  randomIndex    = Math.floor Math.random() * satellite.store.addresses.get().length
  satellite.store.targetAddress satellite.store.addresses.get()[randomIndex]

  # the connect middleware to distribute requests with sticky session ids
  # to specific addresses
exports.strategy = (req, res, next) =>
  if req.headers.cookie?
    if satellite.store.stickySessions.get(req.headers.cookie)?
      satellite.store.targetAddress satellite.store.stickySessions.get req.headers.cookie
    else
      satellite.store.stickySessions.set req.headers.cookie, setRandomTargetAddress()
  else
    setRandomTargetAddress()
  next()