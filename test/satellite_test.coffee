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

      it 'should remove any sticky sessions that are bound to that address', ->
        address4 = host: '192.168.0.4', port: 3000
        cookie = "connect-sid=29ud3hd92h9d992j"
        satellite.addAddress address4        
        satellite.stickySessions[cookie] = address4
        satellite.removeAddress address4
        assert !satellite.stickySessions[cookie]?

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

  describe 'sticky-session strategy', ->

    before (done) ->
      satellite.targetAddress = null #TODO - make tests independent of each other
      @res = {}
      @app = connect() 
      @app.use satellite.stickySessionStrategy
      done()

    describe 'when session id is not present', ->

      before (done) ->
        @req = headers: {}
        done()

      it 'should route the request to a random target address', (done) ->
        @app.stack[0].handle @req, @res, ->
          assert satellite.targetAddress?
          done()
 
    describe 'when session id is present', ->

      before (done) ->
        @cookie = "connect-sid=d23dh92hd98d9h98h98"
        @req    = headers: {cookie: @cookie}
        done()

      it 'should record which address served the request', (done) ->
        @app.stack[0].handle @req, @res, =>
          assert satellite.targetAddress?
          assert.deepEqual satellite.stickySessions.sessions[@cookie], satellite.targetAddress
          done()
        
      it 'should route future requests for that session to the recorded address', (done) ->
        stickySessionAddress = satellite.stickySessions.sessions[@cookie]
        for number in [0..10]
          @app.stack[0].handle @req, @res, =>
            assert satellite.targetAddress?
            assert.deepEqual satellite.targetAddress, stickySessionAddress
            done() if number is 10