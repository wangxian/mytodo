seajs.config({
  debug: false,
  alias: {
    'coffee': 'gallery/coffee/1.6.1/coffee-script.js',
    'jquery': 'gallery/jquery/1.9.1/jquery.js',
    '$'     : 'gallery/jquery/1.9.1/jquery.js'
  },

  // base: '/path/to/base/',
  preload: [ 'seajs/plugin-coffee.js']
});

seajs.use('app/todo.coffee');