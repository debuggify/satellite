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
  add: (address) =>
    Redis.sadd "satellite_addresses", address
  
  # add an address from the list
  remove: (address) =>
    Redis.srem "satellite_addresses", address

  # get the list  
  get: =>
    Redis.smembers "satellite_addresses", Redis.print

# get or set the target Address
exports.targetAddress = (setValue=undefined) =>
  #memory.targetAddress = setValue if setValue?
  #memory.targetAddress

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