# Testing HelloWorldApplication
# You need to load chaplin and all the files that you actually require to test

define [
  'chaplin'
  'test_application'
], (Chaplin, TestApplication) ->
  'use strict'

  describe 'TestApplication', ->

    beforeEach ->
      @test_application = new TestApplication()

    afterEach ->
      # this needs to happen because of testing purpose only
      # https://github.com/documentcloud/backbone/commit/96a7274cf746b3aba6ca0b13866d5d5293c3ad82
      try
        Backbone.history.stop()
      catch e
        console.log(e)


    it 'should have a title, as a string', ->
      expect(@test_application.title).to.be
      expect(@test_application.title).to.be.a('string')