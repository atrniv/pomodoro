define [
  'cs!modules/core'
  'playlyfe'
  'rdust!templates/complete'
], (Core, Playlyfe) ->

  CompleteTaskView = Core.Layout.extend

    id: 'modal'
    template: 'rdust!templates/complete'

    events:
      'click .ok': 'complete'
      'click .cancel': 'cancel'

    serialize: () ->
      console.log @model.get('task').toJSON()
      @model.get('task').toJSON()

    complete: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/fcomplete_task/play", 'POST', () ->
        self.model.get('task').destroy()
        Core.Events.trigger 'stop-timer'
        return

    cancel: () ->
      @remove()
