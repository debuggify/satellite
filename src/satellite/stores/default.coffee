memory = 
  addresses: []
  targetAddress: null
  roundRobin:
    targetAddressIndex: 0
  stickySessions:
    sessions: {}

# The addresses store API functions
exports.addresses =

  # add an address to the list, sync
  addSync: (address) =>
    memory.addresses.push address
  
  # add an address to the list
  add: (address, cb) =>
    memory.addresses.push address
    cb 'success'

  # add an address from the list, sync
  removeSync: (address) =>
    index = memory.addresses.indexOf address
    memory.addresses.splice index, 1

  # add an address from the list
  remove: (address, cb) =>
    index = memory.addresses.indexOf address
    memory.addresses.splice index, 1
    cb 'success'

  # get the list, sync
  getSync: =>
    memory.addresses

  # get the list
  get: (cb) =>
    cb memory.addresses

# get or set the target Address
exports.targetAddressSync = (setValue=undefined) =>
  memory.targetAddress = setValue if setValue?
  memory.targetAddress

# the round robin target address index API
exports.targetAddressIndex =
  
  # get the target address index
  getSync: =>
    memory.roundRobin.targetAddressIndex
  
  # increase the target address index by 1
  incrementSync: =>
    memory.roundRobin.targetAddressIndex += 1

  # set the target address index to 0
  resetSync: =>
    memory.roundRobin.targetAddressIndex = 0
  
# the sticky sessions API    
exports.stickySessions =
  
  # get all the sticky sessions, or just one
  getSync: (key=null) =>
    items = memory.stickySessions.sessions
    if key? then items[key] else items
  
  # set a sticky session by its key and value
  setSync: (key, value) =>
    memory.stickySessions.sessions[key] = value
  
  # remove a sticky session
  deleteSync: (key) =>
    delete memory.stickySessions.sessions[key]