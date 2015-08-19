module TokenAuthenticated
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    attr_reader :current_user
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    authenticate_with_http_token do |token, options|
      user_email = options[:email].presence
      district = District.find_by(slug: request.subdomains.first)
      user = user_email && district && district.users.find_by(email: user_email)

      if user && user.authentication_token == token
        @current_user = user
      else
        head :unauthorized
      end
    end
  end
end
