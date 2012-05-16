assert    = require 'assert'
connect   = require 'connect'
satellite = require '../src/satellite'

describe 'Satellite', ->

  describe 'addresses', ->

    before (done) ->
      @address = host: '192.168.0.1', port: 3000
      done()

    describe 'add an address', ->      

      it 'should append an address to an existing list', ->
        satellite.addAddress @address
        assert.deepEqual satellite.store.addresses.get(), [@address]

      it 'should not add the address if it is already in the list', ->
        satellite.addAddress @address for number in [0..1]
        assert.deepEqual satellite.store.addresses.get(), [@address]        

    describe 'remove an address', ->

      it 'should remove an address from an existing list', ->
        address2  = host: '192.168.0.2', port: 3000
        satellite.addAddress address2
        satellite.removeAddress @address
        assert.deepEqual satellite.store.addresses.get(), [address2]

      it 'should remove any sticky sessions that are bound to that address', ->
        address4 = host: '192.168.0.4', port: 3000
        cookie = "connect-sid=29ud3hd92h9d992j"
        satellite.addAddress address4        
        satellite.store.stickySessions.set cookie, address4
        satellite.removeAddress address4
        assert !satellite.store.stickySessions.get(cookie)?