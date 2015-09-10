$redis ||= Redis.new(url: ENV.fetch('REDIS_URL'))
