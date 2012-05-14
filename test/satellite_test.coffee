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
        assert.deepEqual satellite.addresses, [@address]

      it 'should not add the address if it is already in the list', ->
        satellite.addAddress @address for number in [0..1]
        assert.deepEqual satellite.addresses, [@address]        

    describe 'remove an address', ->

      it 'should remove an address from an existing list', ->
        address2  = host: '192.168.0.2', port: 3000
        satellite.addAddress address2
        satellite.removeAddress @address
        assert.deepEqual satellite.addresses, [address2]

  describe 'round-robin strategy', ->

    before (done) ->
      @req = {}
      @res = {}
      @app = connect() 
      @app.use satellite.roundRobinStrategy
      done()

    it 'should set the target address to an address in the list', ->
      @app.stack[0].handle @req, @res, ->
        assert.deepEqual satellite.targetAddress, satellite.addresses[0]

    it 'should distribute the requests to each address in a sequential order', (done) ->
      satellite.addAddress host: '192.168.0.3', port: 3000
      for request in [0..3]
        for number in [0..1]
          @app.stack[0].handle @req, @res, ->
            assert.deepEqual satellite.targetAddress, satellite.addresses[number]
            done() if request is 3 and number is 1