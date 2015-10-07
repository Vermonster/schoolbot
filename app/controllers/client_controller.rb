class ClientController < ActionController::Base
  include CurrentDistrict

  before_action :redirect_www

  def show
    render text: client_html
  end

  private

  def client_html
    raw_client_html.sub('%%DATA_PRELOAD%%', district_preload.to_json)
  end

  def district_preload
    if root_domain_request?
      { district: { id: 'none' } }
    else
      DistrictSerializer.new(current_district)
    end
  rescue ActiveRecord::RecordNotFound
    { district: { id: 'invalid' } }
  end

  def raw_client_html
    $redis.get('client:index:' + $redis.get('client:index:current'))
  end

  def redirect_www
    if request.subdomains.first == 'www'
      redirect_to '//' + ENV.fetch('APPLICATION_HOST'), status: 301
    end
  end

  def root_domain_request?
    request.host_with_port == ENV.fetch('APPLICATION_HOST')
  end
end
