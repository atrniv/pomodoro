define [
  'cs!modules/core'
  'playlyfe'
  'cs!views/layouts/main'
], (Core, Playlyfe, MainLayout) ->

  AppRouter = Core.Router.extend

    routes:
      '' : 'welcome'
      'splash' : 'splash'
      'splash/:info': 'splash'
      # 'help': 'help'

    initialize: () ->
      @started = false
      Playlyfe.onStatusChange @handleStatus, @
      @mainLayout = new MainLayout( el: '#app' )
      @mainLayout.render()
      Playlyfe.init
        proxy: 'api'
      return

    handleStatus: (status) ->
      console.log(status)
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

    splash: (info = null) ->
      console.log info
      if Playlyfe.getStatus().code is 2 then @welcome()
      else if info? then Core.Events.trigger 'splash', info
      else @mainLayout.viewLogin()
      return

    welcome: () ->
      @mainLayout.viewWelcome()
      return

    help: () ->
      @mainLayout.showHelp()
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

