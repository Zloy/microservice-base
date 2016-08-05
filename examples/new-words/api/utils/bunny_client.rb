#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue(ARGV[1] || 'words jobs')

puts " [*] Waiting for messages in '#{q.name}' queue. To exit press CTRL+C"
q.subscribe(block: true) do |_delivery_info, _properties, body|
  puts " [x] Received #{body}"
end
