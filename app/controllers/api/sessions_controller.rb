module API
  class SessionsController < BaseController
    def create
      if authenticated_user
        render json: {
          token: authenticated_user.authentication_token,
          email: authenticated_user.email
        }, status: 201
      else
        render json: { error: 'errors.session.invalid' }, status: 401
      end
    end

    private

    def authenticated_user
      @_authenticated_user ||= authenticating_user.try(:authenticate, password)
    end

    def authenticating_user
      current_district.users.find_by(email: email)
    end

    def email
      params.require(:user).fetch(:email).downcase.strip
    end

    def password
      params.require(:user).fetch(:password)
    end
  end
end
