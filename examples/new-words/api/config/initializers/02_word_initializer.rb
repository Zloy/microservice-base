require 'bunny'
require 'connection_pool'

require 'word'

Word.configure do |config|
  # config.host = :localhost
  # config.port = 5672
  # config.pool_size = 5
  # config.pool_timeout = 5 # seconds
end
