require 'word'

describe 'My Sinatra Application' do
  it '/status renders ok' do
    get '/status'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('ok')
  end

  it '/w renders 200 OK for authenticated user' do
    user_id = 1234
    get '/w', {}, 'rack.session' => { user_id: user_id }

    expect(last_response).to be_ok
  end

  it '/w renders 404 for anonymous user' do
    get '/w'

    expect(last_response.status).to eq(401)
  end

  it '/w renders application/json content type' do
    user_id = 1234
    get '/w', {}, 'rack.session' => { user_id: user_id }

    expect(last_response.headers['Content-Type']).to eq('application/json')
  end

  it '/w renders what Word.all(user_id) returns in json form' do
    user_id = 1234
    word_data = { key: :val, yet: :another }
    expect(Word).to receive(:all).with(user_id).and_return(word_data)

    get '/w', {}, 'rack.session' => { user_id: user_id }

    expect(last_response.body).to eq(word_data.to_json)
  end
end
