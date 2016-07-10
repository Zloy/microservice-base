require File.expand_path '../spec_helper.rb', __FILE__

describe 'My Sinatra Application' do
  it 'renders status' do
    get '/status'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('ok')
  end
end
