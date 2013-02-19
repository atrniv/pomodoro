define [
  'cs!modules/core'
  'rdust!templates/set-pomodoro'
], (Core) ->

  SetPomodoroView = Core.Layout.extend

    template: 'rdust!templates/set-pomodoro'
    id: 'modal'

    events:
      'click .save': 'save'
      'click .cancel': 'cancel'
      'click .rate-item': 'setPomo'

    initialize: () ->
      @model.on 'change', @render, @
      return

    serialize: () ->
      data = @model.toJSON()
      data.total_minutes = data.total * 25
      data

    save: () ->
      @model.set({ total: parseInt(@$('.set-pomo').data('value')) }, { validate: true })
      if @model.validationError?
        @$('#error').html(@model.validationError).show()
      else
        @remove()
      return

    cancel: () ->
      @remove()
      return

    setPomo: (e) ->
      $el = $(e.target)
      $el.siblings().removeClass('set-pomo')
      $el.addClass('set-pomo')
      @$('.pomo-count').text("#{$el.data('value')} pomidoro")
      @$('.pomo-mins').text("#{$el.data('value')*25} minutes")

    afterRender: () ->
      @$("[data-value='#{@model.get('total')}']").addClass('set-pomo')
