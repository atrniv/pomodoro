define [
  'cs!modules/core'
  'rdust!templates/timer'
], (Core) ->
  TimerView = Core.Layout.extend

    template: 'rdust!templates/timer'

    events:
      'click .start': 'start'
      'click .back': 'back'
      'click .cancel': 'cancel'
      'click .restart': 'restart'
      'click .finish': 'finish'

    initialize: () ->
      @model.on 'change', @render, @
      return

    serialize: () ->
      @model.toJSON()

    start: () ->
      @model.set state: 'started'
      return

    back: () ->
      Core.Events.trigger 'stop-timer'
      return

    cancel: () ->
      @model.set state: 'stopped'
      return

    restart: () ->
      @model.set state: 'started'
      return

    finish: () ->
      Core.Events.trigger 'stop-timer'
      return
