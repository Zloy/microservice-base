require 'user'

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

  @user = session[:user_id] && User.new(session[:user_id], session[:user_name])
end

post '/login' do
  user = User.authenticate(request.body.read)
  if user
    session[:user_id] = user.id
    session[:user_name] = user.name
    status 200
  else
    status 401
  end
end

get '/logout' do
  session[:user_id] = session[:user_name] = @user = nil
  status 200
end

get '/whoami' do
  @user && @user.name || 'anonymous'
end
