Place = require '../models/place'

class PlacesController

  show: (request, response) ->
    slug = request.params.slug
    Place.findBySlug slug, (err, place) ->
      throw err if err
      response.render 'place', { place }

  addVibe: (request, response) ->
    slug = request.params.slug
    console.log "Got vibe reading for #{slug}: #{JSON.stringify(request.body)}"
    Place.findBySlug slug, (err, place) ->
      return response.status(500).send(err).end() if err
      reading = request.body
      place.addReading reading, (err) ->
        return response.status(500).send(err).end() if err
        response.status(200).end()

module.exports = new PlacesController
