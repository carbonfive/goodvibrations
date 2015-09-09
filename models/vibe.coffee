mongoose = require './mongoose'

VibeSchema = new mongoose.Schema
  slug:      { type: String, required: true }
  timestamp: { type: Date, required: true }
  readings:  mongoose.Schema.Types.Mixed

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
    reading.timestamp = m * 60 + s

    arr = [ m*60+s, reading.ambientLight, reading.ambientNoise, reading.numPhones ]
    Vibe.update { slug, timestamp }, { $push: { readings: arr } }, { upsert: true }, done

Vibe = mongoose.model 'Vibe', VibeSchema

module.exports = Vibe
