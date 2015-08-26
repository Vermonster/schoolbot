module API
  class SessionsController < BaseController
    def create
      user = current_district.users.find_by(email: params[:user][:email])

      if user.try(:authenticate, params[:user][:password])
        render json: {
          token: user.authentication_token,
          email: user.email
        }, status: 201
      else
        render json: { error: 'errors.session.invalid' }, status: 401
      end
    end
  end
end
