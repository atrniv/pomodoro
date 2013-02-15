define [
  'cs!modules/core'
  'cs!views/welcome'
  'cs!views/login'
  'cs!views/timer'
  'cs!models/timer'
  'rdust!templates/layouts/main'
], (Core, WelcomeView, LoginView, TimerView, Timer) ->

  MainLayout = Core.Layout.extend

    template: 'rdust!templates/layouts/main'

    initialize: () ->
      Core.Events.on 'start-task', @viewTimer, @
      Core.Events.on 'stop-timer', @viewWelcome, @
      return

    cleanup: () ->
      Core.Events.off null, null, @
      return

    viewWelcome: () ->
      welcomeView = new WelcomeView()
      @getView('#canvas')?.remove()
      @setView '#canvas', welcomeView
      welcomeView.render()
      return

    viewLogin: () ->
      loginView = new LoginView()
      @getView('#canvas')?.remove()
      @setView '#canvas', loginView
      loginView.render()
      return

    viewTimer: () ->
      timerView = new TimerView( model: new Timer() )
      @getView('#canvas')?.remove()
      @setView '#canvas', timerView
      timerView.render()
      return


