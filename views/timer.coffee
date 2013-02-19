define [
  'cs!modules/core'
  'playlyfe'
  'cs!views/complete'
  'rdust!templates/timer'
], (Core, Playlyfe, CompleteTaskView) ->
  TimerView = Core.Layout.extend

    id: 'taskCenter'
    template: 'rdust!templates/timer'

    events:
      'click .start': 'start'
      'mouseover .start': 'showClockAnimation'
      'mouseout .start': 'clearCanvas'
      'click .back': 'back'
      'click .cancel': 'cancel'
      'click .restart': 'restart'
      'click .finish': 'finish'

    initialize: () ->
      @model.on 'change', @render, @
      @model.get('task').on 'change', @render, @
      Playlyfe.api "/trees/#{@model.get('rootId')}/journal", (data) ->
        # console.log data
        return
      Playlyfe.api "/trees/#{@model.get('rootId')}/state", (data) ->
        # console.log data
        return
      return

    serialize: () ->
      data = @model.toJSON()
      data.taskName = data.task.get('title')
      data.pomoDone = new Array()
      data.pomoLeft = new Array()
      data.pomoDone.length = data.task.get('completed')

      left = data.task.get('total') - data.task.get('completed')
      if left > 0
        data.pomoLeft.length = left
      else
        data.pomoLeft.length = 0
      console.log 'Data = ', data
      data

    start: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/ftimer/play", 'POST', () ->
        Playlyfe.api "/trees/#{self.model.get('rootId')}/flows/fstart_timer/play", 'POST', () ->
          _comp = self.model.get('task').get('completed')
          _total = self.model.get('task').get('total')
          if _comp >= _total
            console.log 'Setting total eq', _comp+1
            self.model.get('task').set('total':_comp+1)
          self.model.set state: 'started'
          return
        return
      return

    back: () ->
      Core.Events.trigger 'stop-timer'
      return

    cancel: () ->
      self = @
      Playlyfe.api "/trees/#{@model.get('rootId')}/flows/fcancel_timer/play", 'POST', () ->
        self.model.set state: 'stopped'
        return
      return

    restart: () ->
      @start()
      return

    finish: () ->
      # TODO : end task, remove from collection
      @insertView new CompleteTaskView( model: @model )
      @render()
      return


    afterRender: () ->
      self = @
      do () ->
        $clock = $('#clock')
        canvas = $clock.get(0)
        ctx = canvas.getContext('2d')

        MAXTIME = 25*60
        TIME = $clock.data('min')*60+$clock.data('sec')

        W = canvas.width
        H = canvas.height
        R = W/2-5

        fgColor1 = 'hsl(120, 80%, 35%)'
        fgColor2 = 'hsl(120, 95%, 50%)'
        textColor = 'hsl(120, 20%, 30%)'
        bgColor1 = '#181818'
        bgColor2 = '#111111'
        text = ""
        animation_loop = null

        init = () ->
          # clear the canvas everytime a chart is drawn
          ctx.clearRect(0, 0, W, H)

          # clock-face
          ctx.beginPath()
          ctx.fillStyle = bgColor1
          ctx.arc(W/2, H/2, R+5, 0, Math.PI*2, false)
          ctx.fill()
          # Track Arc
          ctx.beginPath()
          ctx.strokeStyle = bgColor2
          ctx.lineWidth = 9
          ctx.arc(W/2, H/2, R, 0, Math.PI*2, false)
          ctx.stroke()
          return

        drawTicks = () ->
          # darker halo
          radians = (TIME/MAXTIME) * (2 * Math.PI)
          ctx.beginPath()
          ctx.strokeStyle = fgColor1
          ctx.lineWidth = 7
          ctx.lineCap = "round"
          # the arc starts from the rightmost end. If we deduct 90 degrees from the angles
          ctx.arc(W/2, H/2, R, 0 - 90*Math.PI/180, radians - 90*Math.PI/180, true)
          ctx.stroke()

          # brighter center
          ctx.beginPath()
          ctx.strokeStyle = fgColor2
          ctx.lineWidth = 4
          ctx.lineCap = "round"
          ctx.arc(W/2, H/2, R, 0 - 90*Math.PI/180, radians - 90*Math.PI/180, true)
          ctx.stroke()

          # add the text
          ctx.fillStyle = textColor
          ctx.font = "90px Roboto"
          ctx.shadowColor = '#111111'
          ctx.shadowBlur = 1.5
          ctx.shadowOffsetX = 1
          ctx.shadowOffsetY = 1

          _M = $clock.data('min')
          _S = $clock.data('sec')

          MM = if _M > 9 then "#{_M}" else "0#{_M}"
          SS = if _S > 9 then "#{_S}" else "0#{_S}"

          text = "#{MM}:#{SS}"
          text_width = ctx.measureText(text).width
          ctx.fillText(text, W/2 - text_width/2, H/2 + 35)
          return

        startTimer = () ->
          if(TIME == 0)
            clearInterval(animation_loop)
          hue = 120-((MAXTIME-TIME)/MAXTIME)*120
          fgColor1 = "hsl(#{hue}, 80%, 35%)"
          fgColor2 = "hsl(#{hue}, 95%, 50%)"
          textColor = "hsl(#{hue}, 20%, 30%)"
          drawTicks()
          return

        do () ->
          if(typeof animation_loop != undefined)
              clearInterval(animation_loop)
          init()
          if self.model.get('state') is 'started'
            startTimer()
          else
            return

        return

    clearCanvas: () ->
      do () ->
        canvas = $('#clock').get(0)
        ctx = canvas.getContext('2d')
        W = canvas.width
        H = canvas.height
        R = W/2-5
        ctx.beginPath()
        ctx.strokeStyle = '#111111'
        ctx.lineWidth = 9
        ctx.arc(W/2, H/2, R, 0, Math.PI*2, false)
        ctx.stroke()
        return

    showClockAnimation: () ->
      self = @
      do () ->
        canvas = $('#clock').get(0)
        ctx = canvas.getContext('2d')

        MAXTIME = TIME = 10

        W = canvas.width
        H = canvas.height
        R = W/2-5

        animation_loop = null
        fgColor1 = 'hsl(120, 80%, 35%)'
        fgColor2 = 'hsl(120, 95%, 50%)'

        drawTicks = () ->
          if TIME < 0.1
            TIME = 1e-6
            clearInterval(animation_loop)
          radians = (TIME/MAXTIME) * (2 * Math.PI)
          ctx.beginPath()
          ctx.strokeStyle = fgColor1
          ctx.lineWidth = 7
          ctx.lineCap = 'round'
          ctx.arc(W/2, H/2, R, 0 - 90*Math.PI/180, radians - 90*Math.PI/180, true)
          ctx.stroke()

          ctx.beginPath()
          ctx.strokeStyle = fgColor2
          ctx.lineWidth = 4
          ctx.lineCap = 'round'
          ctx.arc(W/2, H/2, R, 0 - 90*Math.PI/180, radians - 90*Math.PI/180, true)
          ctx.stroke()
          return

        tweenTimer = () ->
          # beware here, the TIME goes into negative values
          # if unexpected behaviour occurs, this is be the usual suspect
          TIME -= 0.1
          self.clearCanvas()
          drawTicks()
          hue = 120-((MAXTIME-TIME)/MAXTIME)*120
          fgColor1 = "hsl(#{hue}, 80%, 35%)"
          fgColor2 = "hsl(#{hue}, 95%, 50%)"
          textColor = "hsl(#{hue}, 20%, 30%)"
          return

        do () ->
          if(typeof animation_loop != undefined)
              clearInterval(animation_loop)
          animation_loop = setInterval(tweenTimer, 5)

        return
