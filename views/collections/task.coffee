define [
  'cs!modules/core'
  'cs!views/items/task'
], (Core, TaskItemView) ->
  TaskCollectionView = Core.Layout.extend

    id: 'task-list'

    tagName: 'ul'

    initialize: () ->
      @collection.on 'change', @render, @
      @collection.on 'destroy', @render, @
      @collection.on 'add', @render, @
      @collection.on 'remove', @render, @
      @collection.on 'reset', @render, @
      return

    beforeRender:() ->
      if @collection.models.length is 0
        @insertView(new TaskItemView( model: null ))
      else
        @collection.each((model) ->
          @insertView(new TaskItemView( model: model ))
        , @)
      return
