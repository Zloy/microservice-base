require 'simplecov'
require 'coveralls'

begin
  require 'byebug'
rescue LoadError
  puts 'Failed loading byebug'
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/spec/'
end

Coveralls.wear!

require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    App
  end
end

RSpec.configure { |c| c.include RSpecMixin }
