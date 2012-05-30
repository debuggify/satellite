assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'

emptyHash = (hash) ->
  result = true
  for key, value of hash
    result = false
  result

describe 'redis store', ->

  before (done) ->
    redis = require 'redis'
    redisClient = redis.createClient()
    satellite.useStore 'redis', redisClient, (status) ->
      # This is to clear out the list of addresses that
      # may have been populated by other test files
      satellite.store.addresses.get (addresses) ->
        done() if addresses.length is 0
        for address in addresses
          satellite.store.addresses.remove address, (status) ->
            satellite.store.addresses.get (addr) ->
              done() if addr.length is 0 

  describe 'addresses', ->

    describe 'add', ->
 
      it 'should append the address to the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.add address, (res) ->
          satellite.store.addresses.get (addresses) ->
            assert.deepEqual addresses, [address]
            done()

    describe 'remove', ->
    
      it 'should remove the address from the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.remove address, (status) ->
          satellite.store.addresses.get (addresses) ->
            assert.deepEqual addresses, []
            done()

    describe 'get', ->
      
      it 'should return the list of addresses', (done) ->
        address2 = host: '222.22.222.222', port: 80
        satellite.store.addresses.add address2, (status) ->
          satellite.store.addresses.get (addresses) ->
            assert addresses, [address2]
            done()

  describe 'targetAddress', ->

    describe 'get', ->

      it 'should return the current value of targetAddress', (done) ->
        expectedTargetAddress = host: '222.22.222.222', port: 80
        satellite.store.targetAddress.set expectedTargetAddress, (res) ->
          satellite.store.targetAddress.get (address) ->
            assert.deepEqual address, expectedTargetAddress
            done()

    describe 'set', ->

      it 'should set the current value of targetAddress, and return itself', (done) ->
        eta = host: '333.33.333.333', port: 80
        satellite.store.targetAddress.set eta, (newAddr) ->
          satellite.store.targetAddress.get (addr) ->
            assert.deepEqual addr, eta
            assert.deepEqual newAddr, eta
            done()

  describe 'targetAddressIndex', ->

    describe 'get', ->

      it 'should return the current index of the targetAddress array', (done) ->
        satellite.store.targetAddressIndex.reset (status) ->
          satellite.store.targetAddressIndex.increment (status) ->
            satellite.store.targetAddressIndex.increment (status) ->
              satellite.store.targetAddressIndex.increment (status) ->
                satellite.store.targetAddressIndex.increment (status) ->
                  satellite.store.targetAddressIndex.increment (status) ->
                    satellite.store.targetAddressIndex.get (number) -> 
                      assert.equal number, 5
                      done()

    describe 'increment', ->

      it 'should increase the value of the current index by 1', (done) ->
        satellite.store.targetAddressIndex.reset (status) ->
          satellite.store.targetAddressIndex.increment (status) ->
            satellite.store.targetAddressIndex.get (number) ->
              assert.equal number, 1
              done()

    describe 'reset', ->

      it 'should set the value of the current index to 0', (done) ->
        satellite.store.targetAddressIndex.reset (status) ->
          satellite.store.targetAddressIndex.get (number) ->
            assert.equal number, 0
            done()

  describe 'stickySessions', ->

    before (done) ->
      # This is to clear out the hash of stickySessions that
      # may have been populated by other test files
      satellite.store.stickySessions.get (stickySessions) ->
        done() if emptyHash stickySessions
        for key,value of stickySessions
          satellite.store.stickySessions.delete key, (res) ->
            done()
      #       satellite.store.stickySessions.get (ss) ->
      #         done() if emptyHash ss

    describe 'get', ->

      it 'should return a hash of keys and values', (done) ->
        kv = {"cookie-xxx": {host: '555.55.555.555', port: 80}}
        for key,value of kv
          satellite.store.stickySessions.set key, value, (res) ->
            satellite.store.stickySessions.get (stickySessions) ->
              assert.deepEqual stickySessions, kv
              done()

    describe 'get(key)', ->

      it 'should return the value corresponding to the key in the hash', (done) ->
        value = {host: '555.55.555.555', port: 80}
        satellite.store.stickySessions.get "cookie-xxx", (stickySession) ->
          assert.deepEqual stickySession, value
          done()

    describe 'set', ->

      it 'should set a key and value in the hash', (done) ->
        value = {host: '777.77.777.777', port: 80}
        satellite.store.stickySessions.set "cookie-xxx", value, (status) ->
          satellite.store.stickySessions.get "cookie-xxx", (addr) ->
            assert.deepEqual addr, value
            done()

    describe 'delete', ->

      it 'should delete the key and value from the hash', (done) ->
        value = {host: '777.77.777.777', port: 80}
        key = "cookie-xxx"
        satellite.store.stickySessions.set key, value, (status) ->

          satellite.store.stickySessions.delete key, (res) ->
            satellite.store.stickySessions.get (data) ->
              assert.deepEqual data, {}
              satellite.store.stickySessions.get key, (data) ->
                assert.deepEqual data, undefined
                done()