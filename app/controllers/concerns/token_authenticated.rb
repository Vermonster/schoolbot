module TokenAuthenticated
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    attr_reader :current_user
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    @current_user = authenticate_with_http_token do |token, options|
      district = District.find_by!(slug: request.subdomains.first)
      user = district.users.find_by(email: options[:email].presence)

      user if user.present? && user.authentication_token == token
    end

    head :unauthorized unless @current_user.present?
  end
end
