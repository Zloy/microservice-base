require 'bunny'
require 'connection_pool'

require 'word'

Word.configure do |config|
  config.pool = ConnectionPool.new(size: 5, timout: 5) do
    Bunny.new.tap(:start)
  end
end
