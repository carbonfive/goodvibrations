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

  scene: ->
    if @words['bro'] > 0 and @genderRatio < 1
      { name: 'Bro', expectations: [ 'Popped collars', 'Lots of hats', 'Regrettable tribal tatoos' ] }
    else if @ambientNoise > 0.2
      { name: 'Hoppin\'', expectations: [ 'Dancing', 'Yelling', 'And hopping of course' ] }
    else
      { name: 'Chill', expectations: [ 'Casual conversation', 'Craft beer appreciation', 'Small plates mastication' ] }

  ambience: ->
    if @ambientLight < 0.02
      light = 'Dim'
    else if @ambientLight < 0.04
      light = 'Warm'
    else
      light = 'Bright'

    if @ambientNoise < 0.02
      noise = 'Quiet'
    else if @ambientNoise < 0.04
      noise = 'Bustling'
    else if @ambientNoise < 0.06
      noise = 'Loud'
    else
      noise = 'Raging'

    { light, noise }

Vibe = mongoose.model 'Vibe', VibeSchema

module.exports = Vibe
