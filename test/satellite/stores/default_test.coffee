assert    = require 'assert'
connect   = require 'connect'
satellite = require '../../../src/satellite'

describe 'default store', ->

  describe 'addresses', ->

    describe 'add', ->
      
      it 'should append the address to the list'

    describe 'remove', ->
    
      it 'should remove the address from the list'

    describe 'get', ->

      it 'should return the list of addresses'

  describe 'targetAddress', ->

    describe '()', ->

      it 'should return the current value of targetAddress'

    describe '(set)', ->

      it 'should set the current value of targetAddress, and return itself'

  describe 'targetAddressIndex', ->

    describe 'get', ->

      it 'should return the current index of the targetAddress array'

    describe 'increment', ->

      it 'should increase the value of the current index by 1'

    describe 'reset', ->

      it 'should set the value of the current index to 0'

    describe 'stickySessions', ->

      describe 'get()', ->

        it 'should return a hash of keys and values'

      describe 'get(key)', ->

        it 'should return the value corresponding to the key in the hash'

      describe 'set', ->
        
        it 'should set a key and value in the hash'

      describe 'delete', ->

        it 'should delete the key and value from the hash'