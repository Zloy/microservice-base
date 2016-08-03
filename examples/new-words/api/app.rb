require 'sinatra'
require 'sinatra-initializers'
require File.expand_path 'load_paths.rb', File.dirname(__FILE__)
require 'setup_logger'
require 'login'

register Sinatra::Initializers

get '/status' do
  'ok'
end

get '/w', auth: :user do
  content_type 'application/json'

  Word.all(session[:user_id]).to_json
end

post '/w/:word', auth: :user do
  request.body.rewind
  payload = request.body.read

  content_type 'application/json'
  status 201

  Word.insert_or_update(session[:user_id], params[:word], payload).to_json
end

put '/w/:word/learned', auth: :user do
  status 204
  body nil

  Word.learned(session[:user_id], params[:word])
end

delete '/w/:word', auth: :user do
  status 204
  body nil

  Word.delete(session[:user_id], params[:word])
end
