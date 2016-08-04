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
    yield(config)
  end
end
