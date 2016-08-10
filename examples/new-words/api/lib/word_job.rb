class WordJob
  WORD_VALIDATION_REGEXP = /\A[a-z]+\Z/i

  def self.all(user_id, job_id)
    word = new(type: :all, user_id: user_id, job_id: job_id)

    send(word)

    { job_id: job_id }
  end

  def self.insert_or_update(user_id, word, payload)
    word = new(type: :add, user_id: user_id, word: word, payload: payload)

    send(word)
  end

  def self.learned(user_id, word)
    word = new(type: :learned, user_id: user_id, word: word)

    send(word)
  end

  def self.delete(user_id, word)
    word = new(type: :delete, user_id: user_id, word: word)

    send(word)
  end

  # rubocop:disable Style/TrivialAccessors
  def self.send_lambda=(send_lambda)
    @send_lambda = send_lambda
  end

  def self.send(word)
    word_str = serialize(word.to_h)

    @send_lambda.call(word_str)

    nil
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

  def initialize(type:, user_id:, word: nil, payload: nil, job_id: nil)
    @type = type
    @user_id = user_id
    @word = word
    @payload = payload
    @job_id = job_id
  end

  def to_h
    { type: @type, user_id: @user_id, word: @word, payload: @payload,
      job_id: @job_id }
  end
end
