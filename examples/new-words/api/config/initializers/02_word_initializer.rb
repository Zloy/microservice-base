require 'bunny_pool'
require 'word'
require 'json'

bunny_pool = BunnyPool.new.configure do |config|
  # defaults:
  # config.host = :localhost
  # config.port = 5672
  # config.pool_size = 5
  # config.pool_timeout = 5 # seconds
  config.queue = 'words jobs'
end

Word.send_lambda = bunny_pool.send_lambda

Word.serialize_lambda = -> (obj) { JSON.generate(obj) }
