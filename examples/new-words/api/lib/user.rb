require 'json'

class User
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def self.authenticate(str)
    cred = begin
             JSON.parse(str)
           rescue
             nil
           end
    User.new(1234, 'Anton') if cred_valid?(cred)
  end

  def self.get(user_id)
    user_id == 1234 ? User.new(1234, 'Anton') : nil
  end

  def self.cred_valid?(cred)
    cred.respond_to?(:[]) && cred['name'] == 'Anton' &&
      cred['password'] == 'hello'
  end
end
