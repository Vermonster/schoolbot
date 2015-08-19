module API
  class SessionsController < BaseController
    def create
      if authenticating_user.try(:authenticate, params[:user][:password])
        render json: {
          token: authenticating_user.authentication_token,
          email: authenticating_user.email
        }, status: 201
      else
        render json: { error: 'errors.session.invalid' }, status: 401
      end
    end

    private

    def authenticating_user
      @_authenticating_user ||=
        current_district.users.find_by(email: params[:user][:email])
    end

    def current_district
      @_current_district ||= District.find_by!(slug: request.subdomains.first)
    end
  end
end
