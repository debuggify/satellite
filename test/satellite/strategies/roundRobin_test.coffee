assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'

describe 'round-robin strategy', ->

  before (done) ->
    @req = {}
    @res = {}
    @app = connect() 
    @app.use satellite.roundRobinStrategy
    done()

  it 'should set the target address to an address in the list', (done) ->
    @app.stack[0].handle @req, @res, ->
      satellite.store.targetAddress.get (address) ->
        satellite.store.addresses.get (addresses) ->
          assert.deepEqual address, addresses[0]
          done()

  it 'should distribute the requests to each address in a sequential order', (done) ->
    satellite.addAddress host: '192.168.0.3', port: 3000, (res) =>
      for request in [0..3]
        for number in [0..1]
          @app.stack[0].handle @req, @res, ->
            satellite.store.targetAddress.get (address) ->
              satellite.store.addresses.get (addresses) ->
                assert.deepEqual address, addresses[number]
                done() if request is 3 and number is 1