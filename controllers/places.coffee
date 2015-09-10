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
      place.vibe.addReading name, value for name, value of reading
      place.vibe.save (err, vibe) ->
        return response.status(500).send(err).end() if err
        response.status(200).end()

  addSample: (request, response) ->
    slug = request.params.slug
    console.log "Got sample for #{slug} ..."
    ident request.body, (err, music) ->
      return response.status(500).send(err).end() if err
      console.log "... #{music.track} by #{music.artist} (#{music.genre})"
      Place.findBySlug slug, (err, place) ->
        return response.status(500).send(err).end() if err
        place.vibe.addReading 'musicSong', music.track
        place.vibe.addReading 'musicArtist', music.artist
        place.vibe.addReading 'musicGenre', music.genre
        place.vibe.save (err, vibe) ->
          return response.status(500).send(err).end() if err
          response.status(200).end()

module.exports = new PlacesController
