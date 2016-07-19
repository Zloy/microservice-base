class Word
  def self.all(user_id)
    if user_id == 1234
      { some: :data }
    else
      {}
    end
  end
end
