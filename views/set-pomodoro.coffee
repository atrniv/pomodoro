define [
  'cs!modules/core'
  'rdust!templates/set-pomodoro'
], (Core) ->

  SetPomodoroView = Core.Layout.extend

    template: 'rdust!templates/set-pomodoro'

    events:
      'click .save': 'save'
      'click .cancel': 'cancel'

    initialize: () ->
      @model.on 'change', @render, @

    serialize: () ->
      @model.toJSON()

    save: () ->
      @remove()
      return

    cancel: () ->
      @remove()
      return
