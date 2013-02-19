define [
  'cs!modules/core'
  'underscore'
  'playlyfe'
], (Core, _, Playlyfe) ->
  Task = Core.Model.extend

    defaults:
      'completed': 0
      'total': 1

    validate: (attributes) ->
      if not _.isNumber(attributes.total) or _.isNaN(attributes.total)
        return 'Please select atleast one pomodoro'
      if attributes.total < @get('completed')
        return 'Total pomidoro cannot be less than the number already completed.'
