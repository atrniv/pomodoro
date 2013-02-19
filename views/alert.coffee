define [
  'cs!modules/core'
  'rdust!templates/alert'
], (Core) ->

  CompleteTaskView = Core.Layout.extend

    id: 'modal'
    template: 'rdust!templates/alert'

    events:
      'click': 'close'

    serialize: () ->
      titles = [
        'Get a life!'
        'All work and no play...'
        'Calm your nerves'
        'Chill out'
        'Life is not all about work'
        'Rethink your work-plan'
      ]
      randIdx = Math.floor Math.random()*titles.length
      console.log randIdx
      { title: titles[randIdx] }

    close: () ->
      self = @
      @$el.fadeOut () ->
        self.remove()
      return

