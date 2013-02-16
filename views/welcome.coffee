define [
  'cs!modules/core'
  'cs!models/collections/task'
  'cs!models/task'
  'cs!views/collections/task'
  'playlyfe'
  'rdust!templates/welcome'
], (Core, TaskCollection, Task, TaskCollectionView, Playlyfe) ->
  WelcomeView = Core.Layout.extend

    template: 'rdust!templates/welcome'

    events:
      'click #add-task': 'addTask'
      'keypress #new-task': 'checkAddTask'
      'click #logout': 'logout'

    initialize: () ->
      Core.TASKLIST ?= new TaskCollection()
      @setView '#task-list-wrapper', new TaskCollectionView( collection: Core.TASKLIST ), @

    checkAddTask:(e) ->
      if e.keyCode is 13 then @addTask()
      return

    addTask: () ->
      $taskInput = $('#new-task')
      Core.TASKLIST.add(new Task( title: $taskInput.val() ))
      $taskInput.val('')
      return

    logout: () ->
      Playlyfe.logout()
      return

    serialize: () ->
      { first_name: 'Test' }

