_ = require 'underscore'

mongoose = require './mongoose'
Vibe     = require './vibe'

PlaceSchema = new mongoose.Schema
  slug:  { type: String, required: true, unique: true, dropDups: true }
  name:  { type: String, required: true }

PlaceSchema.virtual('vibes').get ()      -> @_vibes
PlaceSchema.virtual('vibes').set (vibes) -> @_vibes = vibes

PlaceSchema.statics =

  findBySlug: (slug, done) ->
    @findOne { slug }, (err, place) ->
      return done err, place if err
      return done err, place unless place
      Vibe.findRecent slug, (err, vibes) ->
        place.vibes = vibes
        done err, place

PlaceSchema.methods =

  mostRecentReading: ->
    latestVibe = _(@vibes).last()
    _.chain(latestVibe.readings).last().value()

  addReading: (reading, done) ->
    Vibe.add @slug, reading, done

Place = mongoose.model 'Place', PlaceSchema

module.exports = Place
