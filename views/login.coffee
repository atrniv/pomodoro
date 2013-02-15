define [
  'cs!modules/core'
  'playlyfe'
  'rdust!templates/login'
], (Core, Playlyfe) ->

  LoginView = Core.Layout.extend

    template: 'rdust!templates/login'

    events:
      'click #login': 'login'

    initialize: () ->

    login: (e) ->
      Playlyfe.login()
      return
