define [
  'cs!modules/core'
  'playlyfe'
  'cs!models/task'
], (Core, Playlyfe, Task) ->
  TaskCollection = Core.Collection.extend

    initialize: () ->
      @on 'change', @save, @
      @on 'add', @createFlow, @
      @on 'flow:created', @save, @
      @on 'remove', @save, @
      @on 'reset', @save, @
      Core.Events.on 'player:load', @fetch, @
      return

    cleanup: () ->
      Core.Events.off null, null, @
      return

    buildTaskFlow: (task) ->
      tree =
        mode: 'dnormal'
        flows:
          'fmain': { ref: 'pmain', control: 'exit' }
          'fgiveup': { id: 'fgiveup', ref: 'agiveup'}
          'fcomplete_task': { id: 'fcomplete_task', ref: 'acomplete_task' }
          'ftimer': { id: 'ftimer', ref: 'ptimer', loop: -1 }
          'fstart_timer': { id: 'fstart_timer', ref: 'astart_timer' }
          'fstop_timer': { id: 'fstop_timer', ref: 'pstop_timer' }
          'ffinish_timer': { id: 'ffinish_timer', ref: 'afinish_timer' }
          'fcancel_timer': { id: 'fcancel_timer', ref: 'acancel_timer' }

        paths:
          'pmain': { id: 'pmain', order: 'alternative', flows: ['fgiveup', 'fcomplete_task', 'ftimer'], title: task }
          'ptimer': { id: 'ptimer', order: 'sequence', flows: ['fstart_timer', 'fstop_timer'], title: 'Start timer' }
          'pstop_timer': { id: 'pstop_timer', order: 'alternative', flows: ['ffinish_timer', 'fcancel_timer'], title: 'Stop timer' }

        actions:
          'agiveup': { id: 'agiveup', title: 'I give up!' }
          'acomplete_task': { id: 'acomplete_task', title: 'I\'m done with this task!' }
          'afinish_timer': { id: 'afinish_timer', title: 'I finished a pomodoro' }
          'astart_timer': { id: 'astart_timer', title: 'Start the pomodoro' }
          'acancel_timer': { id: 'acancel_timer', title: 'I want to cancel this pomodoro' }

    createFlow: (model) ->
      self = @
      tree = @buildTaskFlow model.get('title')
      Playlyfe.api '/trees', 'POST', tree, (data) ->
        console.log data
        model.set rootId: "#{data.map.mode}:#{Core.PLAYER.id}:#{data.map.flows.fmain}"
        self.trigger 'flow:created'
        return
      return

    url: () ->
      "/entities/#{Core.PLAYER.id}:task-list"

    parse: (response) ->
      response.data

    fetch: (options) ->
      console.log 'fetching'
      self = @
      Playlyfe.api @url(), (response) ->
        if response?
          self.reset(self.parse(response))
        return

    save: () ->
      self = @
      Playlyfe.api @url(), 'PUT', @toJSON(), (response) ->
        return
      return
