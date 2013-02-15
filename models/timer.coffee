define [
  'cs!modules/core'
], (Core) ->
  Timer = Core.Model.extend

    defaults:
      state: 'stopped'

    initialize: () ->
      @timeout = null
      @on 'change:state', (model, state) ->
        console.log state
        switch state
          when 'started'
            @timeout = null
            @set { endTime: new Date( new Date().getTime() + 1000 * 60 * 25) }, { silent: true }
            @tick()
            @timeout = setInterval(((self) ->
              () ->
                self.tick()
                return
            )(@),1000)
          when 'stopped'
            clearInterval(@timeout)

    tick: () ->
      now = new Date()
      millisecs = (@get('endTime') - now)
      @set { minutes: parseInt(Math.floor(millisecs/(1000*60))) }, { silent: true }
      @set seconds: parseInt(Math.floor(millisecs%(1000*60))/1000)
      if millisecs < 0
        clearInterval @timeout
        @set state: 'finished'
      return
