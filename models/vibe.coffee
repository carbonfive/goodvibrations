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
    w = @words ? {}
    if w['bro'] > 0
      { name: 'Bro', expectations: [ 'Popped collars', 'Lots of hats', 'Regrettable tribal tatoos' ] }
    else if @ambientNoise > 0.2
      { name: 'Hoppin\'', expectations: [ 'Dancing', 'Yelling', 'And hopping of course' ] }
    else
      { name: 'Chill', expectations: [ 'Casual conversation', 'Craft beer appreciation', 'Small plates mastication' ] }

  ambience: ->
    light = 'Bright'
    light = 'Dim'  if @ambientLight < 0.02
    light = 'Warm' if @ambientLight < 0.04

    noise = 'Loud'
    noise = 'Quiet'    if @ambientNoise < 0.02
    noise = 'Bustling' if @ambientNoise < 0.04

    { light, noise }

  density: ->
    d = { name: 'Packed',  num: 4 }
    d = { name: 'Sparse',  num: 1 } if @numPhones < 5
    d = { name: 'Busy',    num: 2 } if @numPhones < 15
    d = { name: 'Crowded', num: 3 } if @numPhones < 25

    d

  gender: ->
    r = parseFloat @genderRatio
    percentage = Math.round( ( r / ( r + 1 ) ) * 100 )
    { percentage }

Vibe = mongoose.model 'Vibe', VibeSchema

module.exports = Vibe
