require 'bunny_pool'
require 'word_job'
require 'json'

WordJob.serialize_lambda = -> (obj) { JSON.generate(obj) }

if ENV['RACK_ENV'] == 'test'
  WordJob.send_lambda = -> { raise 'Unexpectedly Word.send() called' }
else
  bunny_pool = BunnyPool.new.configure do |config|
    # defaults:
    # config.host = :localhost
    # config.port = 5672
    # config.pool_size = 5
    # config.pool_timeout = 5 # seconds
    config.queue = 'words jobs'
  end

  WordJob.send_lambda = bunny_pool.send_lambda
end
