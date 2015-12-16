ProtectYourAs = require '../src/protect-your-as'

describe 'ProtectYourAs', ->
  beforeEach ->

    @sut = new ProtectYourAs

  describe '->do', ->
    describe "when calling a job without x-as", ->
      beforeEach (done) ->
        job =
          metadata:
            auth:
              uuid: 'green-blue'
              token: 'blue-purple'
            toUuid: 'bright-green'
            responseId: 'yellow-green'
        @sut.do job, (error, @newJob) => done error

      it 'should get have the responseId', ->
        expect(@newJob.metadata.responseId).to.equal 'yellow-green'

      it 'should get have the status code of 204', ->
        expect(@newJob.metadata.code).to.equal 204

    describe 'when called with a job', ->
      describe "x-as-ing itself", ->
        beforeEach (done) ->
          job =
            metadata:
              auth:
                uuid: 'green-blue'
                token: 'blue-purple'
              toUuid: 'bright-green'
              fromUuid: 'green-blue'
              responseId: 'yellow-green'
          @sut.do job, (error, @newJob) => done error

        it 'should get have the responseId', ->
          expect(@newJob.metadata.responseId).to.equal 'yellow-green'

        it 'should get have the status code of 204', ->
          expect(@newJob.metadata.code).to.equal 204

      describe "where the auth device is trying to do something to the device it is impersonating", ->
        beforeEach (done) ->
          job =
            metadata:
              auth:
                uuid: 'eggs-laid-in-body'
                token: 'supernova'
              toUuid: 'ai-turns-hostile'
              fromUuid: 'ai-turns-hostile'
              responseId: 'alien'
          @sut.do job, (error, @newJob) => done error

        it 'should get have the responseId', ->
          expect(@newJob.metadata.responseId).to.equal 'alien'

        it 'should get have the status code of 403', ->
          expect(@newJob.metadata.code).to.equal 403

      describe "where the auth device is x-as-ing as one device, and doing something to another", ->
        beforeEach (done) ->
          job =
            metadata:
              auth:
                uuid: 'eggs-laid-in-body'
                token: 'supernova'
              toUuid: 'accident'
              fromUuid: 'ai-turns-hostile'
              responseId: 'alien'
          @sut.do job, (error, @newJob) => done error

        it 'should get have the responseId', ->
          expect(@newJob.metadata.responseId).to.equal 'alien'

        it 'should get have the status code of 204', ->
          expect(@newJob.metadata.code).to.equal 204
