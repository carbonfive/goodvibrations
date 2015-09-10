url = require('url')
fs = require('fs')
crypto = require('crypto')
request = require('request')

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

module.exports = (bits, done) ->
  identify new Buffer(bits), defaultOptions, (err, resp, body) ->
    return done err if err
    json = JSON.parse body
    done null, json.metadata.music
