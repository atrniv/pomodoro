define [
  'cs!modules/core'
  'playlyfe'
  'cs!models/task'
], (Core, Playlyfe, Task) ->
  TaskCollection = Core.Collection.extend

    parse: () ->

    fetch: () ->
