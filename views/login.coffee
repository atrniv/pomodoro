define [
  'cs!modules/core'
  'playlyfe'
  'text!/templates/splash/main'
  'text!/templates/splash/technique'
  'text!/templates/splash/about'
  'rdust!templates/login'
], (Core, Playlyfe, tMain, tTechnique, tAbout) ->

  LoginView = Core.Layout.extend

    template: 'rdust!templates/login'

    events:
      'mouseenter .login-wrapper': 'showClockAnimation'
      'mouseleave .login-wrapper': 'clearCanvas'
      'click #login': 'login'

    initialize: () ->
      Core.Events.on 'splash', @showSplash, @
      @screen = 'main'
      return

    login: (e) ->
      Playlyfe.login()
      return

    showSplash: (screen) ->
      switch screen
        when 'technique'
          @$('#gyan').html(tTechnique)
        when 'about'
          @$('#gyan').html(tAbout)
        else
          @$('#gyan').html(tMain)
      return

    afterRender: () ->
      @clearCanvas()
      @showSplash(@screen)

    clearCanvas: (e) ->
      do () ->
        canvas = @$('#clock').get(0)
        ctx = canvas.getContext('2d')
        W = canvas.width
        H = canvas.height
        R = W/2-10
        ctx.beginPath()
        ctx.fillStyle = '#181818'
        ctx.arc(W/2, H/2, R+10, 0, Math.PI*2, false)
        ctx.fill()
        ctx.beginPath()
        ctx.strokeStyle = 'hsl(0,80%,50%)'
        ctx.lineWidth = 9
        ctx.arc(W/2, H/2, R, 0, Math.PI*2, false)
        ctx.stroke()
        return

    showClockAnimation: (e) ->
      self = @
      do () ->
        canvas = @$('#clock').get(0)
        ctx = canvas.getContext('2d')

        MAXTIME = TIME = 10

        W = canvas.width
        H = canvas.height
        R = W/2-10

        animation_loop = null
        fgColor1 = 'hsl(120, 80%, 35%)'

        drawTicks = () ->
          if TIME < 0.1
            TIME = 1e-6
            clearInterval(animation_loop)
          radians = (TIME/MAXTIME) * (2 * Math.PI)

          ctx.beginPath()
          ctx.strokeStyle = fgColor1
          ctx.lineWidth = 9
          ctx.lineCap = 'round'
          ctx.arc(W/2, H/2, R, 0 - 90*Math.PI/180, radians - 90*Math.PI/180, true)
          ctx.stroke()
          return

        tweenTimer = () ->
          self.clearCanvas()
          drawTicks()
          TIME -= 0.1
          hue = (MAXTIME-TIME)/MAXTIME*120
          fgColor1 = "hsl(#{hue}, 80%, 35%)"
          return

        do () ->
          if(typeof animation_loop != undefined)
              clearInterval(animation_loop)
          animation_loop = setInterval(tweenTimer, 10)

        return
