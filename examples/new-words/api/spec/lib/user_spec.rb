require 'json'

describe User do
  RIGHT_CRED = { name: 'Anton', password: 'hello' }.to_json
  WRONG_CRED = { name: 'Anton', password: 'abcde' }.to_json
  BAD_CREDS  = ['', nil, 123, Object.new, [], {}, '-', WRONG_CRED].freeze

  it '.authenticate' do
    user = User.authenticate(RIGHT_CRED)
    expect(user).to respond_to(:id)
    expect(user).to respond_to(:name)

    BAD_CREDS.each do |bad_cred|
      user = User.authenticate(bad_cred)
      expect(user).to be_nil
    end
  end

  it '.get' do
    user = User.get(1234)
    expect(user).to be_a_kind_of(User)
    expect(user.id).to eq(1234)
    expect(user.name).to eq('Anton')

    user = User.get(123)
    expect(user).to be_nil
  end
end
