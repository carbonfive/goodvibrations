_ = require 'underscore'

mongoose = require './mongoose'
Vibe     = require './vibe'

PlaceSchema = new mongoose.Schema
  slug:  { type: String, required: true, unique: true, dropDups: true }
  name:  { type: String, required: true }
  vibe:  { type: mongoose.Schema.Types.ObjectId, ref: 'Vibe' }

PlaceSchema.statics =

  findBySlug: (slug, done) ->
    @findOne({ slug }).populate('vibe').exec done

PlaceSchema.methods =

Place = mongoose.model 'Place', PlaceSchema

module.exports = Place
