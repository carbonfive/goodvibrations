express = require 'express'

placesController = require './controllers/places'

app = express()

app.get '/places/:id', placesController.show
app.post '/places/:id/vibe', placesController.addVibe

app.listen 3000, ->
  console.log "Listening on #{@address().address}:#{@address().port}"

Place = require './models/place'
Place.remove {}, (err) ->
  throw err if err
  Place.create { slug: 'kates', name: 'Kate O\'Briens' }, (err, place) ->
    throw err if err
    #place.addReading { ambientLight: 0.5, ambientNoise: 0.5, numPhones: 10 }, (err, updated) ->
      #throw err if err
