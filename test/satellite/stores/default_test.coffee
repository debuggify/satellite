assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'

emtpyHash = (hash) ->
  result = true
  for key, value of hash
    result = false
  result

describe 'default store', ->

  before (done) ->
    # This is to clear out the list of addresses that
    # may have been populated by other test files
    for address in satellite.store.addresses.getSync()
      satellite.store.addresses.removeSync(address)
      done() if satellite.store.addresses.getSync().length is 0 

  describe 'addresses', ->

    describe 'addSync', ->
      
      it 'should append the address to the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.addSync address
        assert.deepEqual satellite.store.addresses.getSync(), [address]
        done()

    describe 'add', ->
 
      it 'should append the address to the list', (done) ->
        address = host: '111.11.111.111', port: 80
        # we already have an address in the collection from the previous test
        satellite.store.addresses.get (addresses) ->
          assert.deepEqual addresses, [address]
          done()

    describe 'removeSync', ->
    
      it 'should remove the address from the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.removeSync address
        assert.deepEqual satellite.store.addresses.getSync(), []
        done()

    describe 'remove', ->
    
      it 'should remove the address from the list', (done) ->
        address = host: '111.11.111.111', port: 80
        satellite.store.addresses.remove address, (status) ->
          satellite.store.addresses.get (addresses) ->
            assert.deepEqual addresses, []
            done()


    describe 'getSync', ->

      it 'should return the list of addresses', (done) ->
        address2 = host: '222.22.222.222', port: 80
        satellite.store.addresses.addSync address2
        assert satellite.store.addresses.getSync(), [address2]
        done()

    describe 'get', ->
      
      it 'should return the list of addresses', (done) ->
        address2 = host: '222.22.222.222', port: 80
        satellite.store.addresses.add address2, (status) ->
          satellite.store.addresses.get (addresses) ->
            assert addresses, [address2]
            done()


  describe 'targetAddress', ->

    describe '()', ->

      it 'should return the current value of targetAddress', (done) ->
        expectedTargetAddress = host: '222.22.222.222', port: 80
        satellite.store.targetAddressSync expectedTargetAddress
        assert.deepEqual satellite.store.targetAddressSync(), expectedTargetAddress
        done()

    describe '(set)', ->

      it 'should set the current value of targetAddress, and return itself', (done) ->
        eta = host: '333.33.333.333', port: 80
        assert.deepEqual satellite.store.targetAddressSync(eta), eta
        done()

  describe 'targetAddressIndex', ->

    describe 'get', ->

      it 'should return the current index of the targetAddress array', (done) ->
        satellite.store.targetAddressIndex.resetSync()
        satellite.store.targetAddressIndex.incrementSync() for number in [0..4]
        assert.equal satellite.store.targetAddressIndex.getSync(), 5
        done()

    describe 'increment', ->

      it 'should increase the value of the current index by 1', (done) ->
        satellite.store.targetAddressIndex.resetSync()
        satellite.store.targetAddressIndex.incrementSync()
        assert.equal satellite.store.targetAddressIndex.getSync(), 1
        done()

    describe 'reset', ->

      it 'should set the value of the current index to 0', (done) ->
        satellite.store.targetAddressIndex.resetSync()
        assert.equal satellite.store.targetAddressIndex.getSync(), 0
        done()

    describe 'stickySessions', ->

      before (done) ->
        # This is to clear out the hash of stickySessions that
        # may have been populated by other test files
        for key,value of satellite.store.stickySessions.getSync()
          satellite.store.stickySessions.deleteSync key        
          done() if emtpyHash satellite.store.stickySessions.getSync() 

      describe 'getSync()', ->

        it 'should return a hash of keys and values', (done) ->
          kv = {"cookie-xxx": {host: '555.55.555.555', port: 80}}
          for key,value of kv
            satellite.store.stickySessions.setSync key, value
            assert.deepEqual satellite.store.stickySessions.getSync(), kv
            done()

      describe 'getSync(key)', ->

        it 'should return the value corresponding to the key in the hash', (done) ->
          value = {host: '555.55.555.555', port: 80}
          assert.deepEqual satellite.store.stickySessions.getSync("cookie-xxx"), value
          done()


      describe 'setSync', ->
        
        it 'should set a key and value in the hash', (done) ->
          value = {host: '777.77.777.777', port: 80}
          satellite.store.stickySessions.setSync "cookie-xxx", value
          assert.deepEqual satellite.store.stickySessions.getSync("cookie-xxx"), value
          done()

      describe 'deleteSync', ->

        it 'should delete the key and value from the hash', (done) ->
          key = "cookie-xxx"
          satellite.store.stickySessions.deleteSync key
          assert.deepEqual satellite.store.stickySessions.getSync(), {}
          assert.deepEqual satellite.store.stickySessions.getSync(key), undefined
          done()
