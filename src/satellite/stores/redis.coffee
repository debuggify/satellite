redis = require 'redis'
Redis = redis.createClient()


# memory = 
#   addresses: []
#   targetAddress: null
#   roundRobin:
#     targetAddressIndex: 0
#   stickySessions:
#     sessions: {}

# The addresses store API functions
exports.addresses =

  # add an address to the list
  add: (address, cb) =>
    encodedAddress = JSON.stringify address
    Redis.sadd "satellite_addresses", encodedAddress, (err, data) ->
      cb err, data
  
  # add an address from the list
  remove: (address, cb) =>
    encodedAddress = if typeof address is "object"
      JSON.stringify address
    else
      address
    Redis.srem "satellite_addresses", encodedAddress, (err, data) ->
      cb err, data

  # get the list  
  get: (cb) =>
    Redis.smembers "satellite_addresses", (err,data) ->
      cb err, data

# get or set the target Address
exports.targetAddress = (setValueOrCallback, cb) =>
  if typeof setValueOrCallback is "object"
    Redis.set "satellite_targetAddress", JSON.stringify(setValueOrCallback), (err, data) -> 
      cb err, data
  else
    Redis.get "satellite_targetAddress", (err, data) ->
      setValueOrCallback err, JSON.parse data

# the round robin target address index API
exports.targetAddressIndex =
  
  # get the target address index
  get: =>
    #memory.roundRobin.targetAddressIndex
  
  # increase the target address index by 1
  increment: =>
    #memory.roundRobin.targetAddressIndex += 1

  # set the target address index to 0
  reset: =>
    #memory.roundRobin.targetAddressIndex = 0
  
# the sticky sessions API    
exports.stickySessions =
  
  # get all the sticky sessions, or just one
  get: (key=null) =>
    #items = memory.stickySessions.sessions
    #if key? then items[key] else items
  
  # set a sticky session by its key and value
  set: (key, value) =>
    #memory.stickySessions.sessions[key] = value
  
  # remove a sticky session
  delete: (key) =>
    #delete memory.stickySessions.sessions[key]