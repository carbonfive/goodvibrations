mongoose = require './mongoose'

VibeSchema = new mongoose.Schema
  timestamp: { type: Date, required: true }
  numPhones: Number
  ambientNoise: Number
  ambientLight: Number
  musicSong: String
  musicArtist: String
  musicGenre: String
  words: mongoose.Schema.Types.Mixed
  genderRatio: String

VibeSchema.methods =
  addReading: (name, value) ->
    @timestamp = new Date()
    if name == 'words'
      @words ?= {}
      for token in ( value ? [] )
        @words[token] = (@words[token] ? 0) + 1
    else
      @[name] = value

Vibe = mongoose.model 'Vibe', VibeSchema

module.exports = Vibe
