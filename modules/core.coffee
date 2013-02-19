define ['require', 'backbone', 'backbone-layout-manager'], (require, Backbone, LayoutManager) ->
  Backbone.Layout.configure
    manage: true
    fetch: (name) ->
      require name
    render: (template, context) ->
      done = @async()
      template.render(context, (err, output) ->
        throw Error err if err
        done output
        return
      )
      return
  Backbone
