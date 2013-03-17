({
  baseUrl: '.',
  appDir: '.',
  dir: '../public',
  stubModules: ["cs","rdust", "text"],
  pragmasOnSave: {
    excludeCoffeeScript: true
  },
  modules: [
    {
      name: "main",
      exclude: ["coffee-script"]
    }
  ],
  paths: {
    'jquery': 'libs/jquery/jquery-1.9.0',
    'audioLib': 'libs/audiolib/audiolib',
    'underscore': 'libs/underscore/underscore',
    'backbone': 'libs/backbone/backbone',
    'backbone-layout-manager' : 'libs/backbone-plugins/backbone.layoutmanager',
    'state-machine' : 'libs/state-machine/state-machine',
    'coffee-script': 'libs/coffee-script/coffee-script',
    'rdust': 'libs/require-js-plugins/require-dust',
    'cs': 'libs/require-js-plugins/cs',
    'text': 'libs/require-js-plugins/text',
    'dust' : 'libs/dust/dust-full-1.1.1',
    'dust-helpers' : 'libs/dust/dust-helpers-1.1.0',
    'q': 'libs/q/q.min',
    'playlyfe' : 'libs/playlyfe/pl'
  }
})
