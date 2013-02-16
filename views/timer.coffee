define [
  'cs!modules/core'
  'playlyfe'
  'rdust!templates/timer'
], (Core, Playlyfe) ->
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
      Playlyfe.api "/trees/#{@model.get('rootId')}/journal", (data) ->
        console.log data
        return
      Playlyfe.api "/trees/#{@model.get('rootId')}/state", (data) ->
        console.log data
        return
      return

    serialize: () ->
      @model.toJSON()

    start: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/ftimer/play", 'POST', () ->
        Playlyfe.api "/trees/#{self.model.get('rootId')}/flows/fstart_timer/play", 'POST', () ->
          self.model.set state: 'started'
          return
        return
      return

    back: () ->
      Core.Events.trigger 'stop-timer'
      return

    cancel: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/fcancel_timer/play", 'POST', () ->
        self.model.set state: 'stopped'
        return
      return

    restart: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/fstart_timer/play", 'POST', () ->
        self.model.set state: 'started'
        return
      @model.set state: 'started'
      return

    finish: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/ffinish_timer/play", 'POST', () ->
        self.model.set(self.model.get('completed') + 1)
        Core.Events.trigger 'stop-timer'
        return
      return
