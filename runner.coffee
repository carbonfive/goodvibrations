express    = require 'express'
bodyParser = require 'body-parser'

placesController = require './controllers/places'

app = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use express.static "#{__dirname}/../public"
app.use bodyParser.json()

app.get  '/places/:slug',      placesController.show
app.post '/places/:slug/vibe', placesController.addVibe

app.listen 3000, ->
  console.log "Listening on #{@address().address}:#{@address().port}"

Place = require './models/place'
Place.remove {}, (err) ->
  throw err if err
  Place.create { slug: 'kates', name: 'Kate O\'Briens' }, (err, place) ->
    throw err if err
