# This stores the addresses that we want to proxy requests to 
@addresses = []

# The address to handle the proxy request
@targetAddress = null

# Used by the round-robin strategy to pick which address should 
# handle the request
@targetAddressIndex = 0

# Used by the stick-session strategy to record which address
# handled which session
@stickySessions = {}

# Sets a random address in the list as the target address
setRandomTargetAddress = =>
  randomIndex    = Math.floor Math.random() * @addresses.length
  @targetAddress = @addresses[randomIndex]

# Add an address to the list
exports.addAddress = (address) ->
  index = @addresses.indexOf address
  @addresses.push address if index is -1

# Remove an address from the list
exports.removeAddress = (address) =>
  index = @addresses.indexOf address
  @addresses.splice index, 1
  for cookie, addr of @stickySessions
    delete @stickySessions[cookie] if addr is address

# the connect middleware to distribute requests in a round-robin fashion
exports.roundRobinStrategy = (req, res, next) =>
  @targetAddress = @addresses[@targetAddressIndex]
  if @targetAddressIndex is @addresses.length-1
    @targetAddressIndex = 0
  else 
    @targetAddressIndex += 1
  next()

# the connect middleware to distribute requests with sticky session ids
# to specific addresses
exports.stickySessionStrategy = (req, res, next) =>
  if req.headers.cookie?
    if @stickySessions[req.headers.cookie]?
      @targetAddress = @stickySessions[req.headers.cookie]      
    else
      @stickySessions[req.headers.cookie] = setRandomTargetAddress()
  else
    setRandomTargetAddress()
  next()