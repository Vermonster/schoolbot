class ClientController < ActionController::Base
  def show
    render text: client_html
  end

  private

  def client_html
    $redis.get($redis.get('client:current'))
  end
end
