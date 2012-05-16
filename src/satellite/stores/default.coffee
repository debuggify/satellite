memory = 
  addresses: []
  targetAddress: null
  roundRobin:
    targetAddressIndex: 0
  stickySessions:
    sessions: {}

exports.addresses =
  add: (address) =>
    memory.addresses.push address
  remove: (address) =>
    index = memory.addresses.indexOf address
    memory.addresses.splice index, 1
  get: =>
    memory.addresses

exports.targetAddress = (setValue=undefined) =>
  memory.targetAddress = setValue if setValue?
  memory.targetAddress

exports.targetAddressIndex =
  get: =>
    memory.roundRobin.targetAddressIndex
  increment: =>
    memory.roundRobin.targetAddressIndex += 1
  reset: =>
    memory.roundRobin.targetAddressIndex = 0
      
exports.stickySessions =
  get: (key=null) =>
    items = memory.stickySessions.sessions
    if key? then items[key] else items
  set: (key, value) =>
    memory.stickySessions.sessions[key] = value
  delete: (key) =>
    delete memory.stickySessions.sessions[key]