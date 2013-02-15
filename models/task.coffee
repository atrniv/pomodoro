define [
  'cs!modules/core'
  'underscore'
  'playlyfe'
], (Core, _, Playlyfe) ->
  Task = Core.Model.extend

    defaults:
      'completed': 0
      'total': 0

    validate: (attributes) ->
      if attributes.total < @get('completed')
        return 'Total pomodoros cannot be less than the number already completed.'
      if not _.isNumber(attributes.total) or _.isNaN(attributes.total)
        return 'Please enter a number'
