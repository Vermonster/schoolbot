class ClientController < ActionController::Base
  def show
    render text: client_html
  end

  private

  def client_html
    redis.get(redis.get('client:current'))
  end

  def redis
    @redis ||= Redis.new(url: ENV.fetch('REDIS_URL'))
  end
end
