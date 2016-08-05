require 'sinatra'
require 'sinatra-initializers'
require File.expand_path 'load_paths.rb', File.dirname(__FILE__)

class App < Sinatra::Application
  register Sinatra::Initializers

  require 'setup_logger'
  require 'login'
  require 'words'

  get '/status' do
    'ok'
  end
end
