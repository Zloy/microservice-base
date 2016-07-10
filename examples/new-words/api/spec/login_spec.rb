require File.expand_path '../spec_helper.rb', __FILE__

describe 'Sinatra authentication subsystem' do
  it '/login sets user_id and returns success' do
    body = 'right auth info'
    expect(User).to receive(:authenticate).with(body).and_return(User.new)
    user_id = 1234
    expect_any_instance_of(User).to receive(:id).and_return(user_id)

    post '/login', body

    expect(last_response.status).to eq(200)
    expect(last_response.body).to be_empty
    expect(last_request.session['user_id']).to eq(user_id)
  end

  it '/login doesnt set user_id and returns 401' do
    body = 'wrong auth info'
    expect(User).to receive(:authenticate).with(body).and_return(nil)

    post '/login', body

    expect(last_response.status).to eq(401)
    expect(last_response.body).to be_empty
    expect(last_request.session['user_id']).to be_nil
  end

  it '/logout clears user_id' do
    user_id = 1234
    get '/logout', '', 'rack.session' => { user_id: user_id }

    expect(last_response.status).to eq(200)
    expect(last_response.body).to be_empty
    expect(last_request.session['user_id']).to be_nil
  end

  it '/whoami returns user name' do
    expect(User).to receive(:get).and_return(User.new)
    user_name = 'Alice'
    expect_any_instance_of(User).to receive(:name).and_return(user_name)

    user_id = 1234
    get '/whoami', {}, 'rack.session' => { user_id: user_id }

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq(user_name)
  end

  it '/whoami returns anonymous' do
    get '/whoami', {}, 'rack.session' => {}

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('anonymous')
  end
end
