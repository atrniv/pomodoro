define [
  'cs!modules/core'
  'playlyfe'
  'cs!views/layouts/main'
], (Core, Playlyfe, MainLayout) ->

  AppRouter = Core.Router.extend

    routes:
      '' : 'welcome'
      'splash' : 'splash'
      'splash/:info': 'showScreen'

    initialize: () ->
      @started = false
      Playlyfe.onStatusChange @handleStatus, @
      @mainLayout = new MainLayout( el: '#app' )
      @mainLayout.render()
      # @handleStatus({code:0})
      Playlyfe.init
        client_id: 'MWUyZDQzNWMtY2NkZS00ZjdkLTg5MmYtZjE1ODZhZmZlZGRm'
        redirect_uri: "http://games.localhost:8080/pomodoro"
      return

    handleStatus: (status) ->
      if not @started
        Core.history.start()
        @started = true
      switch status.code
        when 2
          Playlyfe.api '/me', (data) ->
            Core.PLAYER = data
            Core.Events.trigger 'player:load'
            return
          break
        else
          Core.PLAYER = null
          @navigate 'splash', trigger: true
          break
      return

    splash: () ->
      @mainLayout.viewLogin()
      return

    showScreen: (info) ->
      Core.Events.trigger "splash", info

    welcome: () ->
      @mainLayout.viewWelcome()
      return

  initialize: ->
    Core.CSRF = $('body').data('csrf')
    $.ajaxSetup
      beforeSend: (xhr, settings) ->
        return if (settings.crossDomain)
        return if (settings.type is 'GET')
        if (Core.CSRF)
          xhr.setRequestHeader('X-CSRF-Token', Core.CSRF)

    app = new AppRouter()
    return

