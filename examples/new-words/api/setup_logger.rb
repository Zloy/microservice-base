require 'logger'

::Logger.class_eval { alias_method :write, :<< }

access_log = File.join(File.dirname(File.expand_path(__FILE__)),
                       'log', 'access.log')
access_logger = ::Logger.new(access_log)

error_log = File.join(File.dirname(File.expand_path(__FILE__)),
                      'log', 'error.log')
error_logger = File.new(error_log, 'a+')
error_logger.sync = true

configure do
  use Rack::CommonLogger, access_logger
end

before do
  env['rack.errors'] = error_logger
end
