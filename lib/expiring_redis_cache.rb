# github.com/alexreisner/geocoder/blob/master/examples/autoexpire_cache_redis.rb

class ExpiringRedisCache
  def initialize(store, ttl = 1.day.to_i)
    @store = store
    @ttl = ttl
  end

  def [](url)
    @store.[](url)
  end

  def []=(url, value)
    @store.[]=(url, value)
    @store.expire(url, @ttl)
  end

  def keys
    @store.keys
  end

  def del(url)
    @store.del(url)
  end
end
