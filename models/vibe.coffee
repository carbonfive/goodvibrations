mongoose = require './mongoose'

VibeSchema = new mongoose.Schema
  timestamp: { type: Date, required: true }
  numPhones: Number
  ambientNoise: Number
  ambientLight: Number

VibeSchema.methods =
  addReading: (name, value) ->
    @timestamp = new Date()
    @[name] = value

Vibe = mongoose.model 'Vibe', VibeSchema

module.exports = Vibe
