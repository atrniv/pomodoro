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
      return

    serialize: () ->
      @model.toJSON()

    save: () ->
      @model.set({ total: parseInt(@$('input').val()) }, { validate: true })
      if @model.validationError?
        @$('#error').html(@model.validationError)
      else
        @remove()
      return

    cancel: () ->
      @remove()
      return
