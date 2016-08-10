require 'app'
require 'word_job'

describe App do
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

  it 'GET /w renders what WordJob.all(user_id) returns in json form' do
    user_id = 1234
    word_data = { key: :val, yet: :another }
    expect(WordJob).to receive(:all)
      .with(user_id, anything).and_return(word_data)

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

  it 'POST /w/:word renders what WordJob.insert_or_update returns json' do
    word = 'hero'
    payload = 'payload here!'
    word_data = { word => payload }
    user_id = 1234
    expect(WordJob).to receive(:insert_or_update)
      .with(user_id, word, payload, anything)
      .and_return(word_data)

    post '/w/hero', payload, 'rack.session' => { user_id: user_id }

    expect(last_response.body).to eq(word_data.to_json)
  end

  it 'PUT /w/:word/learned renders 404 for anonymous user' do
    put '/w/hero/learned'

    expect(last_response.status).to eq(401)
  end

  it 'PUT /w/:word/learned renders 204 and calls WordJob.learned' do
    word = 'hero'
    user_id = 1234
    expect(WordJob).to receive(:learned).with(user_id, word, anything)

    put "/w/#{word}/learned", {}, 'rack.session' => { user_id: user_id }

    expect(last_response.status).to eq(204)
    expect(last_response.body).to be_empty
  end

  it 'DELETE /w/:word renders 404 for anonymous user' do
    delete '/w/hero'

    expect(last_response.status).to eq(401)
    expect(last_response.body).to be_empty
  end

  it 'DELETE /w/:word renders 204 and calls WordJob.learned' do
    word = 'hero'
    user_id = 1234
    expect(WordJob).to receive(:delete).with(user_id, word, anything)

    delete "/w/#{word}", {}, 'rack.session' => { user_id: user_id }

    expect(last_response.status).to eq(204)
    expect(last_response.body).to be_empty
  end

  # params[:word] validation testing
  user_id = 1234
  bad_words = ['1', '$', 'a_', 'a-', 'a+']

  bad_words.each do |word|
    it "DELETE /w/#{word} renders 422" do
      delete "/w/#{word}", {}, 'rack.session' => { user_id: user_id }

      expect(last_response.status).to eq(422)
      expect(last_response.body).to be_empty
    end

    it "PUT /w/#{word}/learned renders 422" do
      put "/w/#{word}/learned", {}, 'rack.session' => { user_id: user_id }

      expect(last_response.status).to eq(422)
      expect(last_response.body).to be_empty
    end

    it "POST /w/#{word} renders 422" do
      post "/w/#{word}", 'payload here!', 'rack.session' => { user_id: user_id }

      expect(last_response.status).to eq(422)
      expect(last_response.body).to be_empty
    end
  end
end
