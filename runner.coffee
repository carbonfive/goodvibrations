express    = require 'express'
bodyParser = require 'body-parser'

placesController = require './controllers/places'

app = express()
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use express.static "public"
app.use bodyParser.json()
app.use bodyParser.raw type: [ 'audio/wav', 'audio/mp4' ], limit: '1024kb'

app.get  '/places',              placesController.index
app.get  '/places/:slug',        placesController.show
app.post '/places/:slug/vibe',   placesController.addVibe
app.post '/places/:slug/sample', placesController.addSample

app.listen 3000, ->
  console.log "Listening on #{@address().address}:#{@address().port}"

Place = require './models/place'
Vibe = require './models/vibe'
Place.findBySlug 'kates', (err, place) ->
  throw err if err
  unless place
    console.log "Creating Kate O'Briens !"
    Place.create { slug: 'kates', name: 'Kate O\'Briens' }, (err, place) ->
      throw err if err
      place.vibe = new Vibe()
      place.vibe.timestamp = new Date()
      place.vibe.save (err, vibe) ->
        throw err if err
      place.save (err, vibe) ->
        throw err if err
