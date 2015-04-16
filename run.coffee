express    = require('express')
app        = do express

# Todo controller
todo = require './app/controllers/todo'

# Load middleware
if app.get('env') is 'product'
  app.use express.logger()
  mongourl = 'mongodb://2cf524f8-50ad-431c-ad88-9aa48b3d5aea:6ff449ab-b765-4f98-b447-4472599beeab@10.0.29.251:25750/db?auto_reconnect=true'
else
  app.use express.logger('dev')
  app.use '/assets', express.directory( __dirname + '/assets' )
  app.locals.pretty = true
  mongourl = 'localhost:27017/todo?auto_reconnect=true';


# Connect to mongodb
mongo  = require 'mongoskin';
db     = mongo.db(mongourl, {safe: false});
global.tododb = db.bind('todo');

# app.use express.basicAuth 'admin', 'wx'

app.use express.bodyParser()
app.use '/assets', express.static( __dirname + '/assets' )
app.use express.favicon()
app.set('view engine', 'jade');
app.set 'views', __dirname + '/app/views/'


# Router app
app.get '/', todo.index
app.get '/todo', todo.list
app.post '/todo', todo.add
app.delete '/todo/:id', todo.del
app.put '/todo/:id', todo.update

app.get '/env', (req, res)->
  res.send(process.env)

# 404 page
app.use (req, res, next)->
  res.send(404, 'Sorry, cant find that page!')

# 500
# app.use (err, req, res, next)->
#   console.error err.stack
#   res.send(500, 'Something broke!')

app.listen(process.env.VCAP_APP_PORT or 4000)
console.log "server start at: http://0.0.0.0:"+ (process.env.VCAP_APP_PORT or 4000)