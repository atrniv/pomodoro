define [
  'cs!modules/core'
  'rdust!templates/delete'
], (Core) ->

  DeleteTaskView = Core.Layout.extend

    template: 'rdust!templates/delete'

    events:
      'click .delete': 'delete'
      'click .cancel': 'cancel'

    serialize: () ->
      @model.toJSON()

    delete: () ->
      @model.destroy()

    cancel: () ->
      @remove()
