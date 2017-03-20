module API
  class SessionsController < BaseController
    def create
      if authenticated_user
        mobile_device_token_registration
        render json: {
          token: authenticated_user.authentication_token,
          email: authenticated_user.email
        }, status: 201
      else
        render json: { error: 'errors.session.invalid' }, status: 401
      end
    end

    private

    def set_new_auth_and_device_tokens
      old_device_token = authenticated_user.device_token
      authenticated_user.update(authentication_token: SecureRandom.hex, device_token: params[:device_token])
      unless old_device_token.nil?
        # TODO: Send notification to old user
      end
    end

    def mobile_device_token_registration
      new_device = false
      if params[:device_token].present?
        new_device = authenticated_user.device_token.nil? ? true : new_device?
      end
      set_new_auth_and_device_tokens if new_device
    end

    def new_device?
      authenticated_user.device_token != params[:device_token]
    end

    def authenticated_user
      @_authenticated_user ||= authenticating_user&.authenticate(password)
    end

    def authenticating_user
      if @_current_district.nil?
        User.where(email: email).where.not(confirmed_at: nil).first
      else
        current_district.users.confirmed.find_by(email: email)
      end
    end

    def email
      params.require(:user).fetch(:email).downcase.strip
    end

    def password
      params.require(:user).fetch(:password)
    end
  end
end
