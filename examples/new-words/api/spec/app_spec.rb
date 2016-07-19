require 'word'

describe 'My Sinatra Application' do
  it 'GET /status renders ok' do
    get '/status'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('ok')
  end

  it 'GET /w renders 200 OK for authenticated user' do
    user_id = 1234
    get '/w', {}, 'rack.session' => { user_id: user_id }

    expect(last_response).to be_ok
  end

  it 'GET /w renders 404 for anonymous user' do
    get '/w'

    expect(last_response.status).to eq(401)
  end

  it 'GET /w renders application/json content type' do
    user_id = 1234
    get '/w', {}, 'rack.session' => { user_id: user_id }

    expect(last_response.headers['Content-Type']).to eq('application/json')
  end

  it 'GET /w renders what Word.all(user_id) returns in json form' do
    user_id = 1234
    word_data = { key: :val, yet: :another }
    expect(Word).to receive(:all).with(user_id).and_return(word_data)

    get '/w', {}, 'rack.session' => { user_id: user_id }

    expect(last_response.body).to eq(word_data.to_json)
  end

  it 'POST /w/:word renders 404 for anonymous user' do
    post '/w/hero'

    expect(last_response.status).to eq(401)
  end

  it 'POST /w/:word renders application/json content type' do
    user_id = 1234
    post '/w/hero', 'payload here!', 'rack.session' => { user_id: user_id }

    expect(last_response.headers['Content-Type']).to eq('application/json')
    expect(last_response.status).to eq(201)
  end

  it 'POST /w/:word renders what Word.insert_or_update returns in json form' do
    word = 'hero'
    payload = 'payload here!'
    word_data = { word => payload }
    user_id = 1234
    expect(Word).to receive(:insert_or_update).with(user_id, word, payload)
      .and_return(word_data)

    post '/w/hero', payload, 'rack.session' => { user_id: user_id }

    expect(last_response.body).to eq(word_data.to_json)
  end
end
