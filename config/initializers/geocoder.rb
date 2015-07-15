require 'expiring_redis_cache'

Geocoder.configure(
  timeout: 2,
  lookup: :geocodio,
  use_https: true,
  api_key: ENV.fetch('GEOCODER_KEY'),
  cache: ExpiringRedisCache.new(Redis.new(url: ENV.fetch('REDIS_URL')))
)
