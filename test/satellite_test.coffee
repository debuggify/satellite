assert    = require 'assert'
connect   = require 'connect'
satellite = require '../src/satellite'

describe 'Satellite', ->

  describe 'addresses', ->

    before (done) ->
      @address = host: '192.168.0.1', port: 3000
      done()

    describe 'addAddressSync', ->      

      it 'should append an address to an existing list', ->
        satellite.addAddressSync @address
        assert.deepEqual satellite.store.addresses.getSync(), [@address]

      it 'should not add the address if it is already in the list', ->
        satellite.addAddressSync @address for number in [0..1]
        assert.deepEqual satellite.store.addresses.getSync(), [@address]        

    describe 'addAddress', ->

      it 'should append an address to an existing list', (done) ->
        satellite.addAddress @address, (status) =>
          satellite.store.addresses.get (addresses) =>
            assert.deepEqual [@address], addresses
            done()

      it 'should not add the address if it is already in the list', (done) ->
        for number in [0..1]
          satellite.addAddress @address, (status) =>
            if number is 1
              satellite.store.addresses.get (addresses) =>
                assert.deepEqual addresses, [@address]
                done()

    describe 'removeAddressSync', ->

      it 'should remove an address from an existing list', ->
        address2  = host: '192.168.0.2', port: 3000
        satellite.addAddressSync address2
        satellite.removeAddressSync @address
        assert.deepEqual satellite.store.addresses.getSync(), [address2]

      it 'should remove any sticky sessions that are bound to that address', ->
        address4 = host: '192.168.0.4', port: 3000
        cookie = "connect-sid=29ud3hd92h9d992j"
        satellite.addAddressSync address4        
        satellite.store.stickySessions.setSync cookie, address4
        satellite.removeAddressSync address4
        assert !satellite.store.stickySessions.getSync(cookie)?

    describe 'removeAddress', ->

      it 'should remove an address from an existing list', (done) ->
        address2  = host: '192.168.0.2', port: 3000
        satellite.addAddress address2, (status) =>
          satellite.removeAddress @address, (status) =>
            satellite.store.addresses.get (addresses) =>
              assert.deepEqual addresses, [address2]
              done()

      # it 'should remove any sticky sessions that are bound to that address', ->
      #   address4 = host: '192.168.0.4', port: 3000
      #   cookie = "connect-sid=29ud3hd92h9d992j"
      #   satellite.addAddressSync address4        
      #   satellite.store.stickySessions.setSync cookie, address4
      #   satellite.removeAddressSync address4
      #   assert !satellite.store.stickySessions.getSync(cookie)?

