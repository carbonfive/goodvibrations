#! /usr/bin/env ruby

require 'open3'
require 'json'

sox_location = ARGV[0]
wave_location = ARGV[1]

# run sox and grab output
cmd = "#{sox_location} #{wave_location} -n stat -freq"
output = ""
Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
  output << stderr.read
end

male_vals = {}
female_vals = {}

output.each_line do |line|
  splits = line.split(" ")
  freq = splits[0].to_f
  val = splits[1].to_f

  if freq > 85.0 && freq < 165.0
    male_vals[freq] = val
  elsif freq > 180.0 && freq < 255.0
    female_vals[freq] = val
  end
end

res = {}
res[:males] = male_vals.each_value.reduce(&:+)
res[:females] = female_vals.each_value.reduce(&:+)

f_to_m_ratio = {}.tap do |h|
  h[:f_to_m] = (res[:females] / res[:males]).to_f
end
puts JSON.dump f_to_m_ratio
