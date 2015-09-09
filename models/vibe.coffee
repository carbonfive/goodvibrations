mongoose = require './mongoose'

ReadingSchema = new mongoose.Schema
  ambientLight: { type: Number }
  ambientNoise: { type: Number }
  numPhones:    { type: Number }
, { _id: false }

VibeSchema = new mongoose.Schema
  slug:      { type: String, required: true }
  timestamp: { type: Date, required: true }
  readings:  [ ReadingSchema ]

VibeSchema.statics =
  hourStamp: (d) ->
    new Date d.getFullYear(), d.getMonth(), d.getDate(), d.getHours()

  findRecent: (slug, done) ->
    timestamp = @hourStamp new Date()
    Vibe.find { slug, timestamp }, done

  add: (slug, reading, done) ->
    now = new Date()
    timestamp = @hourStamp now
    m = now.getMinutes()
    s = now.getSeconds()

    setter = { $set: undefined }
    setter["readings.#{m * 60 + s}"] = reading
    options = { upsert: true }
    Vibe.update { slug, timestamp }, setter, options, done

Vibe = mongoose.model 'Vibe', VibeSchema

module.exports = Vibe
