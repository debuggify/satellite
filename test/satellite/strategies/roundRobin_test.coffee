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

  it 'should set the target address to an address in the list', ->
    @app.stack[0].handle @req, @res, ->
      assert.deepEqual satellite.store.targetAddressSync(), satellite.store.addresses.getSync()[0]

  it 'should distribute the requests to each address in a sequential order', (done) ->
    satellite.addAddressSync host: '192.168.0.3', port: 3000
    for request in [0..3]
      for number in [0..1]
        @app.stack[0].handle @req, @res, ->
          assert.deepEqual satellite.store.targetAddressSync(), satellite.store.addresses.getSync()[number]
          done() if request is 3 and number is 1