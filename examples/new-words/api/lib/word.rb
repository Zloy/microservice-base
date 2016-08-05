class Word
  WORD_VALIDATION_REGEXP = /\A[a-z]+\Z/i

  def self.all(user_id)
    if user_id == 1234
      { some: :data }
    else
      {}
    end
  end

  def self.insert_or_update(user_id, word, payload)
    word = new(type: :add, user_id: user_id, word: word, payload: payload)

    send(word)
  end

  def self.learned(_user_id, _word)
  end

  def self.delete(_user_id, _word)
  end

  # rubocop:disable Style/TrivialAccessors
  def self.send_lambda=(send_lambda)
    @send_lambda = send_lambda
  end

  def self.send(word)
    word_str = serialize(word.to_h)

    @send_lambda.call(word_str)
  end

  def self.serialize_lambda=(serialize_lambda)
    @serialize_lambda = serialize_lambda
  end
  # rubocop:enable Style/TrivialAccessors

  def self.serialize(obj)
    @serialize_lambda.call(obj)
  end

  def self.valid?(word)
    WORD_VALIDATION_REGEXP =~ word
  end

  def initialize(type:, user_id:, word:, payload:) # Ruby 2.1. named parameters!
    @type = type
    @user_id = user_id
    @word = word
    @payload = payload
  end

  def to_h
    { type: @type, user_id: @user_id, word: @word, payload: @payload }
  end
end
