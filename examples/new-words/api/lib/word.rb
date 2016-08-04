require 'ostruct'

module Word
  def self.all(user_id)
    if user_id == 1234
      { some: :data }
    else
      {}
    end
  end

  def self.insert_or_update(_user_id, _word, _payload)
  end

  def self.learned(_user_id, _word)
  end

  def self.delete(_user_id, _word)
  end

  def self.config
    @config ||= OpenStruct.new
  end

  def self.configure
    yield config

    @pool = create_pool config

    # to send a message
    # @pool.with { |conn| conn.call("Hello world! #{Time.now}") }
  end

  def self.create_pool(config)
    ConnectionPool.new(pool_params_from_config(config)) do
      bunny_params = bunny_params_from_config(config)
      conn = Bunny.new(bunny_params)
      conn.start
      ch = conn.create_channel
      q = ch.queue(bunny_params[:queue])
      -> (str) { ch.default_exchange.publish(str, routing_key: q.name) }
    end
  end

  def self.pool_params_from_config(config)
    {}.tap do |params|
      params[:size] = config.pool_size || 5
      params[:timeout] = config.pool_timeout || 5 # seconds
    end
  end

  def self.bunny_params_from_config(config)
    {}.tap do |params|
      params[:host] = config.host if config.host
      params[:port] = config.port if config.port
      params[:queue] = config.queue || 'words jobs'
    end
  end
end
