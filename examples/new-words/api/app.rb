require 'sinatra'
require File.expand_path 'load_paths.rb', File.dirname(__FILE__)
require 'login'

get '/status' do
  'ok'
end

get '/w', auth: :user do
  ''
end
