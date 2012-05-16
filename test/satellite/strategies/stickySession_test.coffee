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
        assert satellite.store.targetAddress()?
      done()

  describe 'when session id is present', ->

    before (done) ->
      @cookie = "connect-sid=d23dh92hd98d9h98h98"
      @req    = headers: {cookie: @cookie}
      done()

    it 'should record which address served the request', (done) ->
      @app.stack[0].handle @req, @res, =>
        assert satellite.store.targetAddress()?
        assert.deepEqual satellite.store.stickySessions.get(@cookie), satellite.store.targetAddress()
        done()
      
    it 'should route future requests for that session to the recorded address', (done) ->
      stickySessionAddress = satellite.store.stickySessions.get(@cookie)
      for number in [0..10]
        @app.stack[0].handle @req, @res, =>
          assert satellite.store.targetAddress()?
          assert.deepEqual satellite.store.targetAddress(), stickySessionAddress
          done() if number is 10