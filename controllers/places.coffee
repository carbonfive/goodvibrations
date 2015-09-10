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
      return response.status(500).sendStatus(err).end() if err
      reading = request.body
      place.vibe.addReading name, value for name, value of reading
      place.vibe.save (err, vibe) ->
        return response.status(500).sendStatus(err).end() if err
        response.status(200).end()

  addSample: (request, response) ->
    slug = request.params.slug
    console.log "Got sample for #{slug} ..."
    ident request.body, (err, data) ->
      return response.status(500).sendStatus(err).end() if err
      console.log "... #{data.track} by #{data.artist} (#{data.genre})"
      console.log "... words: #{data.words}"
      Place.findBySlug slug, (err, place) ->
        return response.status(500).sendStatus(err).end() if err
        place.vibe.addReading 'musicSong',   data.track  if data.track
        place.vibe.addReading 'musicArtist', data.artist if data.artist
        place.vibe.addReading 'musicGenre',  data.genre  if data.genre
        place.vibe.addReading 'words',       data.words  if data.words
        place.vibe.markModified 'words'                  if data.words
        place.vibe.save (err, vibe) ->
          console.log place
          return response.status(500).sendStatus(err).end() if err
          response.status(200).end()

module.exports = new PlacesController
