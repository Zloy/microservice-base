require './lib/user'

use Rack::Session::Cookie, key: 'rack.session',
                           expire_after: 2_592_000, # In seconds
                           secret: 'some_secret'

register do
  def auth(type)
    condition { halt 401 unless send("#{type}?") }
  end
end

helpers do
  def user?
    @user != nil
  end
end

before do
  next if ['/login', '/logout'].include? request.path_info

  @user = session[:user_id] && User.get(session[:user_id])
end

post '/login' do
  user = User.authenticate(request.body.read)
  session[:user_id] = user && user.id

  status(user.nil? ? 401 : 200)
  body ''
end

get '/logout' do
  session[:user_id] = nil
end

get '/whoami' do
  @user && @user.name || 'anonymous'
end
