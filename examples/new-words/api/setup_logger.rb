require 'logger'
require 'request_id_logger'
require 'rack-request-id'

dir_name = File.dirname(File.expand_path(__FILE__))

access_log = File.join(dir_name, 'log', 'access.log')
error_log = File.join(dir_name, 'log', 'error.log')

access_logger = ::Logger.new(access_log)
error_logger = File.new(error_log, 'a+')
error_logger.sync = true

configure do
  use RequestIdLogger, access_logger
  use Rack::RequestId
end

before do
  env['rack.errors'] = error_logger
end
