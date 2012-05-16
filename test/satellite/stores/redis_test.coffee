assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'

emtpyHash = (hash) ->
  result = true
  for key, value of hash
    result = false
  result

describe 'redis store', ->

  before (done) ->
    # This is to clear out the list of addresses that
    # may have been populated by other test files
    satellite.setStore 'redis', ->
      satellite.store.addresses.get (err, list) ->
        if list.length is 0
          done()
        else
          satellite.store.addresses.get (err, list) ->
            for address in list
              satellite.store.addresses.remove address, (err, data) ->
                satellite.store.addresses.get (err, list) ->
                  if list.length is 0
                    done()
   
  describe 'addresses', ->

    describe 'add', ->
      
      it 'should append the address to the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.add address, (err, data) ->
          satellite.store.addresses.get (err, list) ->
            assert list, [address]
            done()

    describe 'remove', ->
    
      it 'should remove the address from the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.remove address, (err,data) ->
          satellite.store.addresses.get (err, list) ->
            assert list, [address]
            done()

    describe 'get', ->

      it 'should return the list of addresses', (done) ->
        address2 = host: '222.22.222.222', port: 80
        satellite.store.addresses.add address2, (err, data) ->
          satellite.store.addresses.get  (err, list) ->
            assert list, [address2]
            done()


  describe 'targetAddress', ->

    describe '(cb)', ->

      it 'should return the current value of targetAddress', (done) ->
        expectedTargetAddress = host: '222.22.222.222', port: 80
        satellite.store.targetAddress expectedTargetAddress, (err, data) ->
          satellite.store.targetAddress (err, data) ->
            assert.deepEqual data, expectedTargetAddress
            done()

    describe '(data, cb)', ->

      it 'should set the current value of targetAddress, and return itself', (done) ->
        eta = host: '333.33.333.333', port: 80
        satellite.store.targetAddress eta, (err, data) ->
          satellite.store.targetAddress (err, data) ->
            assert.deepEqual data, eta
            done()

  # describe 'targetAddressIndex', ->

  #   describe 'get', ->

  #     it 'should return the current index of the targetAddress array', (done) ->
  #       satellite.store.targetAddressIndex.reset()
  #       satellite.store.targetAddressIndex.increment() for number in [0..4]
  #       assert.equal satellite.store.targetAddressIndex.get(), 5
  #       done()

  #   describe 'increment', ->

  #     it 'should increase the value of the current index by 1', (done) ->
  #       satellite.store.targetAddressIndex.reset()
  #       satellite.store.targetAddressIndex.increment()
  #       assert.equal satellite.store.targetAddressIndex.get(), 1
  #       done()

  #   describe 'reset', ->

  #     it 'should set the value of the current index to 0', (done) ->
  #       satellite.store.targetAddressIndex.reset()
  #       assert.equal satellite.store.targetAddressIndex.get(), 0
  #       done()

  #   describe 'stickySessions', ->

  #     before (done) ->
  #       # This is to clear out the hash of stickySessions that
  #       # may have been populated by other test files
  #       for key,value of satellite.store.stickySessions.get()
  #         satellite.store.stickySessions.delete key        
  #         done() if emtpyHash satellite.store.stickySessions.get() 

  #     describe 'get()', ->

  #       it 'should return a hash of keys and values', (done) ->
  #         kv = {"cookie-xxx": {host: '555.55.555.555', port: 80}}
  #         for key,value of kv
  #           satellite.store.stickySessions.set key, value
  #           assert.deepEqual satellite.store.stickySessions.get(), kv
  #           done()

  #     describe 'get(key)', ->

  #       it 'should return the value corresponding to the key in the hash', (done) ->
  #         value = {host: '555.55.555.555', port: 80}
  #         assert.deepEqual satellite.store.stickySessions.get("cookie-xxx"), value
  #         done()


  #     describe 'set', ->
        
  #       it 'should set a key and value in the hash', (done) ->
  #         value = {host: '777.77.777.777', port: 80}
  #         satellite.store.stickySessions.set "cookie-xxx", value
  #         assert.deepEqual satellite.store.stickySessions.get("cookie-xxx"), value
  #         done()

  #     describe 'delete', ->

  #       it 'should delete the key and value from the hash', (done) ->
  #         key = "cookie-xxx"
  #         satellite.store.stickySessions.delete key
  #         assert.deepEqual satellite.store.stickySessions.get(), {}
  #         assert.deepEqual satellite.store.stickySessions.get(key), undefined
  #         done()

after (done) ->
  done()
  # put this line in to kill the process once done
  process.exit 0