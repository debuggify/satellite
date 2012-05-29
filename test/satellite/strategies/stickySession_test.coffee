assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'

describe 'sticky-session strategy', ->

  before (done) ->
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
        satellite.store.targetAddress.get (number) ->
          assert number?
          done()

  describe 'when session id is present', ->

    before (done) ->
      @cookie = "connect-sid=d23dh92hd98d9h98h98"
      @req    = headers: {cookie: @cookie}
      done()

    it 'should record which address served the request', (done) ->
      @app.stack[0].handle @req, @res, =>
        satellite.store.targetAddress.get (address) =>
          assert address?
          satellite.store.stickySessions.get @cookie, (cookieAddr) =>
            assert.deepEqual cookieAddr, address
            done()
      
    it 'should route future requests for that session to the recorded address', (done) ->
      satellite.store.stickySessions.get @cookie, (stickySessionAddress) =>
        for number in [0..10]
          @app.stack[0].handle @req, @res, =>
            satellite.store.targetAddress.get (address) ->
              assert address? 
              assert.deepEqual address, stickySessionAddress
              done() if number is 10