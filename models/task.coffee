define [
  'cs!modules/core'
  'playlyfe'
], (Core, Playlyfe) ->
  Task = Core.Model.extend

    fetch: () ->
