memory = 
  addresses: []
  targetAddress: null
  roundRobin:
    targetAddressIndex: 0
  stickySessions:
    sessions: {}

# The addresses store API functions
exports.addresses =
  
  # add an address to the list
  add: (address, cb) =>
    memory.addresses.push address
    cb 'success'

  # add an address from the list
  remove: (address, cb) =>
    index = memory.addresses.indexOf address
    memory.addresses.splice index, 1
    cb 'success'

  # get the list
  get: (cb) =>
    cb memory.addresses

# get or set the target Address
exports.targetAddress =
  
  # Get the current address
  get: (cb) =>
    cb memory.targetAddress

  # Set the current address
  set: (value, cb) =>
    memory.targetAddress = value
    cb value

# the round robin target address index API
exports.targetAddressIndex =  
  
  # get the target address index
  get: (cb) =>
    cb memory.roundRobin.targetAddressIndex

  # increase the target address index by 1
  increment: (cb) =>
    memory.roundRobin.targetAddressIndex += 1
    cb 'success'

  # set the target address index to 0
  reset: (cb) =>
    memory.roundRobin.targetAddressIndex = 0
    cb 'success'
  
# the sticky sessions API    
exports.stickySessions =
    
  # get all the sticky sessions, or just one
  get: (keyOrCb, cb=null) =>
    items = memory.stickySessions.sessions
    if cb is null
      keyOrCb items
    else
      cb items[keyOrCb]

  # set a sticky session by its key and value
  set: (key, value, response) =>
    memory.stickySessions.sessions[key] = value
    response 'success'
  
  # remove a sticky session
  delete: (key, cb) =>
    delete memory.stickySessions.sessions[key]
    cb 'success'