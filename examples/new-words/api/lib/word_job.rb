class WordJob
  WORD_VALIDATION_REGEXP = /\A[a-z]+\Z/i

  def self.all(user_id, job_id, datetime_after)
    hash = { type: :all, user_id: user_id, job_id: job_id,
             datetime_after: datetime_after }
    word = new hash

    send(word)

    { job_id: job_id }
  end

  def self.insert_or_update(user_id, word, payload, job_id)
    hash = { type: :add, user_id: user_id, word: word, payload: payload,
             job_id: job_id }
    word = new hash

    send(word)
  end

  def self.learned(user_id, word, job_id)
    hash = { type: :learned, user_id: user_id, word: word, job_id: job_id }
    word = new hash

    send(word)
  end

  def self.delete(user_id, word, job_id)
    hash = { type: :delete, user_id: user_id, word: word, job_id: job_id }
    word = new hash

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

  def initialize(hash)
    @type = hash[:type]
    @user_id = hash[:user_id]
    @datetime_after = hash[:datetime_after]
    @word = hash[:word]
    @payload = hash[:payload]
    @job_id = hash[:job_id]
  end

  def to_h
    { type: @type, user_id: @user_id, word: @word, payload: @payload,
      datetime_after: @datetime_after, job_id: @job_id }
  end
end
