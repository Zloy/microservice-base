require 'bunny'
require 'connection_pool'
require 'ostruct'

class BunnyPool
  def create_pool(config)
    ConnectionPool.new(pool_params_from_config(config)) do
      bunny_params = bunny_params_from_config(config)
      conn = Bunny.new(bunny_params)
      conn.start
      ch = conn.create_channel
      q = ch.queue(bunny_params[:queue])
      -> (str) { ch.default_exchange.publish(str, routing_key: q.name) }
    end
  end

  def pool_params_from_config(config)
    {}.tap do |params|
      params[:size] = config.pool_size || 5
      params[:timeout] = config.pool_timeout || 5 # seconds
    end
  end

  def bunny_params_from_config(config)
    {}.tap do |params|
      params[:host] = config.host if config.host
      params[:port] = config.port if config.port
      params[:queue] = config.queue || 'BunnyPool'
    end
  end

  def config
    @config ||= OpenStruct.new
  end

  def configure
    yield config

    @pool = create_pool config

    self
  end

  def send_lambda
    lambda do |str|
      @pool.with { |conn| conn.call(str) }
    end
  end
end
