request = require('request')

'''
export TOKEN=NWGHQAIVV6ICTYG5S477XVIN3NYD7IG7
curl -XPOST 'https://api.wit.ai/speech?v=20141022' \
   -i -L \
   -H "Authorization: Bearer $TOKEN" \
   -H "Content-Type: audio/wav" \
   --data-binary "@sample.wav"
'''

BEARER_TOKEN='NWGHQAIVV6ICTYG5S477XVIN3NYD7IG7'

module.exports = (bits, done) ->
  options =
    url: 'https://api.wit.ai/speech?v=20141022',
    headers:
     'Authorization': "Bearer #{BEARER_TOKEN}"
     'Content-Type': 'audio/wav'
    body: bits

  request.post options, done
