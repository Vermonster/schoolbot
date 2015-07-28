module API
  class BaseController < ActionController::Base
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_user!

    respond_to :json

    rescue_from ActiveRecord::RecordNotFound do
      head :not_found
    end

    private

    def authenticate_user!
      authenticate_user_from_token!
      super
    end

    def authenticate_user_from_token!
      authenticate_with_http_token do |token, options|
        user_email = options[:email].presence
        user = user_email && User.find_by(email: user_email)

        if user && Devise.secure_compare(user.authentication_token, token)
          sign_in user, store: false
        end
      end
    end
  end
end
