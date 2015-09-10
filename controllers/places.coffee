Place = require '../models/place'
Vibe  = require '../models/vibe'
ident = require '../models/ident'

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
      unless place.vibe
        place.vibe = new Vibe()
        place.save()
      place.vibe.addReading name, value for name, value of reading
      place.vibe.save (err, vibe) ->
        return response.status(500).send(err).end() if err
        response.status(200).end()

  addSample: (request, response) ->
    slug = request.params.slug
    console.log "Got sample for #{slug}"
    ident request.body, (err, result) ->
      return response.status(500).send(err).end() if err
      console.log result[0]
      song = result[0].title
      artist = result[0].artists[0].name
      genre = null
      Place.findBySlug slug, (err, place) ->
        return response.status(500).send(err).end() if err
        unless place.vibe
          place.vibe = new Vibe()
          place.save()
        place.vibe.addReading 'musicSong', song
        place.vibe.addReading 'musicArtist', artist
        place.vibe.addReading 'musicGenre', genre
        place.vibe.save (err, vibe) ->
          return response.status(500).send(err).end() if err
          response.status(200).end()

module.exports = new PlacesController
