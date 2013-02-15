define [
  'cs!modules/core'
  'playlyfe'
  'cs!views/layouts/main'
], (Core, Playlyfe, MainLayout) ->

  AppRouter = Core.Router.extend

    routes:
      '' : 'welcome'
      'login' : 'login'

    initialize: () ->
      @started = 0

      @mainLayout = new MainLayout( el: '#app' )
      @mainLayout.render()

      Playlyfe.onStatusChange @handleStatus, @

      Playlyfe.init
        client_id: 'ZTQ5YjVjNDUtNGVmMy00NzQxLWJmZjUtMWFlN2ExM2JjMzhh'
        redirect_uri: "http://games.playlyfe.com/pomodoro"

      return

    handleStatus: (status) ->
      if not @started
        Core.history.start()
        @started = true
      switch status.code
        when 2

          break
        else
          @navigate 'login', trigger: true
          break
      return

    login: () ->
      @mainLayout.viewLogin()
      return

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

