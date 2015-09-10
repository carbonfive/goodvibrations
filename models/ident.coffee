url = require('url')
fs = require('fs')
crypto = require('crypto')
request = require('request')
xml2js = require('xml2js')
speech = require('./speech')
async = require 'async'
_ = require 'underscore'
cp = require 'child_process'

defaultOptions =
  host: 'ap-southeast-1.api.acrcloud.com',
  endpoint: '/v1/identify',
  signature_version: '1',
  data_type:'audio',
  secure: true,
  access_key: 'e7c3de864312c4ad9b94a166b657b556',
  access_secret: 'ImYMy7Zwii6ls6YrbnURdjSIp99dXRwOSdmpGNhy'

buildStringToSign = (method, uri, accessKey, dataType, signatureVersion, timestamp) ->
  [method, uri, accessKey, dataType, signatureVersion, timestamp].join('\n')

sign = (signString, accessSecret) ->
  crypto.createHmac('sha1', accessSecret)
    .update(new Buffer(signString, 'utf-8'))
    .digest().toString('base64')

identify = (data, options, cb) ->
  current_data = new Date()
  timestamp = current_data.getTime()/1000
  stringToSign = buildStringToSign 'POST', options.endpoint, options.access_key, options.data_type, options.signature_version, timestamp
  signature = sign stringToSign, options.access_secret

  formData =
    sample: data,
    access_key:options.access_key,
    data_type:options.data_type,
    signature_version:options.signature_version,
    signature:signature,
    sample_bytes:data.length,
    timestamp:timestamp,

  request.post
    url: "http://"+options.host + options.endpoint,
    method: 'POST',
    formData: formData
  , cb

gracenote = (artist, track, done) ->
  url = 'https://c1781215998.web.cddbp.net/webapi/xml/1.0/'
  client = '1781215998-FAAE8412FF83C89E61835BE4571B4406'
  user = '280162098686141199-CF7C5F9AA018AE00D39A2C198AF6DCFF'
  method = 'POST'
  body = """
<QUERIES>
  <LANG>eng</LANG>
  <AUTH>
    <CLIENT>#{client}</CLIENT>
    <USER>#{user}</USER>
  </AUTH>
  <QUERY CMD="ALBUM_SEARCH">
    <TEXT TYPE="ARTIST">#{artist}</TEXT>
    <TEXT TYPE="TRACK_TITLE">#{track}</TEXT>
  </QUERY>
</QUERIES>
"""
  request.post { url, method, body }, (err, resp, body) ->
    return done err if err
    xml2js.parseString body, (err, result) ->
      return done err if err
      resp = result.RESPONSES.RESPONSE[0]
      album = resp.ALBUM[0]
      genre = album.GENRE[0]._
      done null, { genre }

_music = (bits, done) ->
  identify new Buffer(bits), defaultOptions, (err, resp, body) ->
    return done err if err
    return done resp.message unless resp.statusCode == 200
    json = JSON.parse body
    music = json.metadata?.music?[0]
    return done null, {} unless music

    track = music.title
    artist = music.artists[0]?.name
    gracenote artist, track, (err, result) ->
      return done err if err
      genre = result.genre
      done null,  { track, artist, genre }

_words = (bits, done) ->
  speech bits, (err, result) ->
    return done err if err
    body = result.body
    return done null, {} unless body
    text = JSON.parse(body)._text
    return done null, {} unless text
    words = text.split(' ')
    done null, { words }

_genders = (fn, done) ->
  cp.execFile "#{__dirname}/../scripts/ftomratio.rb", [ 'sox', fn ], (err, stdout, stderr) ->
    return done err if err
    json = JSON.parse stdout
    done null, { genderRatio: json.f_to_m }

wavify = (bits, done) ->
  fn = "#{__dirname}/../tmp/#{Date.now()}"
  fs.writeFile fn, bits, (err) ->
    return done err if err
    cp.execFile "#{__dirname}/../scripts/wavify.sh", [ fn ], (err, stdout, stderr) ->
      return done err if err
      fs.readFile "#{fn}.wav", (err, data) ->
        return done err if err
        done null, "#{fn}.wav", data

module.exports = (bits, done) ->
  wavify bits, (err, fn, wav) ->
    funcs = [
      ( (cb) -> _music wav, cb ),
      ( (cb) -> _words wav, cb ),
      ( (cb) -> _genders fn, cb )
    ]
    async.parallel funcs, (err, results) ->
      combine = (memo, result) -> _(memo).extend result
      data = _(results).reduce combine, {}
      done err, data
