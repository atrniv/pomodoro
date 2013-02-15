define [
  'cs!modules/core'
  'cs!views/delete'
  'cs!views/set-pomodoro'
  'rdust!templates/items/task'
  'rdust!templates/items/no-task'
], (Core, DeleteTaskView, SetPomodoroView) ->
  TaskItemView = Core.Layout.extend

    template: 'rdust!templates/items/task'

    events:
      'click .start-task': 'startTask'
      'click .cancel-task': 'cancelTask'
      'click .set-pomodoros': 'setPomodoros'

    initialize: () ->
      if @model?
        @model.on 'change', @render, @
      else
        @template = 'rdust!templates/items/no-task'

    serialize: () ->
      if @model?
        @model.toJSON()

    startTask: () ->
      Core.Events.trigger 'start-task', @model

    cancelTask: () ->
      @insertView new DeleteTaskView( model: @model )
      @render()

    setPomodoros: () ->
      @insertView new SetPomodoroView( model: @model )
      @render()


