# The addresses store API functions
exports.addresses =
  
  # add an address to the list
  add: (address, cb) =>
    key = "#{address.host}_#{address.port}"
    @redisClient.hset key, 'host', address.host, (res) =>
      @redisClient.hset key, 'port', address.port, (res) =>
        @redisClient.sadd "#{@namespace}_addresses", key, (err,data) =>
          res = if !err then 'success' else "error: #{err}"
          cb res

  # add an address from the list
  remove: (address, cb) =>
    key = "#{address.host}_#{address.port}"
    @redisClient.srem "#{@namespace}_addresses", key, (res) =>
      @redisClient.del key, (res) =>
        cb 'success'

  # get the list
  get: (cb) =>
    resultSet = []
    @redisClient.smembers "#{@namespace}_addresses", (err,members) =>
      if members.length > 0
        for member in members
          @redisClient.hgetall member, (err,hash) =>
            resultSet.push hash if hash?
            cb resultSet if members.indexOf(member) is members.length-1
      else
        cb resultSet

# get or set the target Address
exports.targetAddress =
  
  # Get the current address
  get: (cb) =>
    @redisClient.hgetall "#{@namespace}_targetaddress", (err, ta) ->
     cb ta

  # Set the current address
  set: (value, cb) =>
    @redisClient.hset "#{@namespace}_targetaddress", 'host', value.host, (err, ta) =>
      @redisClient.hset "#{@namespace}_targetaddress", 'port', value.port, (err, ta) =>
        cb value    

# the round robin target address index API
exports.targetAddressIndex =  
  
  # get the target address index
  get: (cb) =>
    @redisClient.get "#{@namespace}_targetaddressindex", (err, tai) ->
      cb tai

  # increase the target address index by 1
  increment: (cb) =>
    @redisClient.incr "#{@namespace}_targetaddressindex", (err, tai) ->
      cb 'success'

  # set the target address index to 0
  reset: (cb) =>
    @redisClient.set "#{@namespace}_targetaddressindex", 0, (err, tai) ->
      cb 'success'
  
# the sticky sessions API    
exports.stickySessions =
    
  # get all the sticky sessions, or just one
  get: (keyOrCb, cb=null) =>
    if cb is null
      resultSet = {}
      @redisClient.smembers "#{@namespace}_stickysessions", (err, ss) =>
        if ss.length is 0
          keyOrCb resultSet
        else
          for item in ss
            @redisClient.hgetall item, (err, hash) =>
              resultSet[item] = hash
              if ss.indexOf(item) is ss.length-1
                keyOrCb resultSet    
    else
      @redisClient.hgetall keyOrCb, (err, hash) =>
        hash = undefined if hash is null
        cb hash

  # set a sticky session by its key and value
  set: (key, value, response) =>
    @redisClient.hset key, 'host', value.host, (res) =>
      @redisClient.hset key, 'port', value.port, (res) =>
        @redisClient.sadd "#{@namespace}_stickysessions", key, (err,data) =>
          response 'success'
  
  # remove a sticky session
  delete: (key, cb) =>
    @redisClient.srem "#{@namespace}_stickysessions", key, (res) =>
      @redisClient.del key, (err, ss) =>
        cb 'success'