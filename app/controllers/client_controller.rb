class ClientController < ActionController::Base
  before_action :redirect_www

  def show
    render text: client_html
  end

  private

  def client_html
    $redis.get('client:index:' + $redis.get('client:index:current'))
  end

  def redirect_www
    if request.subdomains.first == 'www'
      redirect_to '//' + ENV.fetch('APPLICATION_HOST'), status: 301
    end
  end
end
