mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/goodvibrations_development'
mongoose.connection.on 'error', (err) ->
  console.log "Mongoose error: #{err}"

module.exports = mongoose
