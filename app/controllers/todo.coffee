
exports.index      = (req, res, next)->
  console.log req.user
  res.render('index')

exports.list    = (req, res)->
  tododb.find().sort({finished:-1, _id:1}).toArray (err, data)->
    # console.log err, data
    if(err)
      res.send 500, err.stack
    else
      res.json data

exports.add        = (req, res)->
  req.body.post_date = new Date()
  tododb.save req.body, (err, data)->
    if err
      res.send 500, err.stack
    else
      res.json data

exports.del        = (req, res)->
  tododb.removeById req.param('id')
  res.send('1')

exports.update     = (req, res)->

  id   = req.param('id')
  delete req.body._id
  data = req.body
  # console.dir [id, data]

  tododb.updateById id, data, (err, data)->
    if err
      res.send 500, err.stack
    else
      res.json data