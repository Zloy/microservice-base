require 'word'

describe Word do
  it '.all returns empty object for invalid user_id' do
    invalid_user_ids = [nil, 0, -1, 0.01, '1234', 'string', Object.new,
                        Time.now]

    invalid_user_ids.each do |user_id|
      expect(Word.all(user_id)).to be_empty
    end
  end

  it '.all returns not empty object for valid user_id' do
    expect(Word.all(1234)).not_to be_empty
  end
end
