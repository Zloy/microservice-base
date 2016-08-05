require 'app'

describe App do
  it 'GET /status renders ok' do
    get '/status'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('ok')
  end
end
