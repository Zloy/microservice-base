require 'sinatra'
require 'sinatra-initializers'
require File.expand_path 'load_paths.rb', File.dirname(__FILE__)

class App < Sinatra::Application
  require 'setup_logger'
  require 'login'

  register Sinatra::Initializers

  get '/status' do
    'ok'
  end

  require 'words'
end
