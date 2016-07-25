require 'rack/commonlogger'

class RequestIdLogger < Rack::CommonLogger
  FORMAT = %(%s - %s [%s] "%s %s%s %s" %d %s %0.4f - %s\n).freeze

  X_REQUEST_ID = 'X-Request-Id'.freeze

  private

  def log(env, status, headers, began_at)
    end_at = Time.now

    msg = get_msg(env, status, headers, began_at, end_at)

    send_to_logger(logger, msg)
  end

  # rubocop:disable Metrcis/MethodLength
  def get_msg(env, status, headers, began_at, end_at)
    format(FORMAT, remote_addr(env),
           remote_user(env),
           time2str(end_at),
           env['REQUEST_METHOD'],
           env['PATH_INFO'],
           query(env),
           env['HTTP_VERSION'],
           status.to_s[0..3],
           extract_content_length(headers),
           end_at - began_at,
           request_id(headers))
  end
  # rubocop:enable Metrcis/MethodLength

  def remote_addr(env)
    env['HTTP_X_FORWARDED_FOR'] || env['REMOTE_ADDR'] || '-'
  end

  def remote_user(env)
    env['REMOTE_USER'] || '-'
  end

  def query(env)
    env['QUERY_STRING'].empty? ? '' : '?' + env['QUERY_STRING']
  end

  def time2str(time)
    time.strftime('%d/%b/%Y:%H:%M:%S %z')
  end

  def request_id(headers)
    headers[X_REQUEST_ID]
  end

  def send_to_logger(logger, msg)
    if logger.respond_to?(:write)
      logger.write(msg)
    else
      logger << msg
    end
  end

  def logger
    @logger || env['rack.errors']
  end
end
