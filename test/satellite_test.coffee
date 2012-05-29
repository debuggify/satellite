assert    = require 'assert'
connect   = require 'connect'
satellite = require '../src/satellite'

describe 'Satellite', ->

  describe 'addresses', ->

    before (done) ->
      @address = host: '192.168.0.1', port: 3000
      done()

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

    describe 'removeAddress', ->

      it 'should remove an address from an existing list', (done) ->
        address2  = host: '192.168.0.2', port: 3000
        satellite.addAddress address2, (status) =>
          satellite.removeAddress @address, (status) =>
            satellite.store.addresses.get (addresses) =>
              assert.deepEqual addresses, [address2]
              done()

      it 'should remove any sticky sessions that are bound to that address', (done) ->
        address4 = host: '192.168.0.4', port: 3000
        cookie = "connect-sid=29ud3hd92h9d992j"
        satellite.addAddress address4, (status) ->
          satellite.store.stickySessions.set cookie, address4, (setCb) ->
            satellite.removeAddress address4, (rmCb) ->
              satellite.store.stickySessions.get cookie, (result) ->
                assert !result?
                done()

