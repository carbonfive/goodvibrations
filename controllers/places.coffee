Place = require '../models/place'

class PlacesController

  show: (request, response) ->
    id = request.params.id
    Place.findById id, (err, place) ->
      throw err if err
      response.render place, { place }

  addVibe: (request, response) ->
    id = request.params.id
    Place.findById id, (err, place) ->
      throw err if err
      vibe = request.body
      place.addVibe vibe, (err) ->
        throw err if err

module.exports = new PlacesController
