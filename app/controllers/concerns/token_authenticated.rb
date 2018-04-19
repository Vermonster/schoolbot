module TokenAuthenticated
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include CurrentDistrict

  included do
    attr_reader :current_user
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    @current_user = authenticate_with_http_token do |token, options|
      current_district.users.confirmed.find_by(
        email: options[:email].presence,
        authentication_token: token
      )
    end

    head :unauthorized if @current_user.blank?
  end
end
