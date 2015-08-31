module API
  class UsersController < BaseController
    include TokenAuthenticated

    def show
      respond_with current_user
    end

    def update
      current_user.update(user_params)
      respond_with current_user, location: nil
    end

    private

    def user_params
      params.require(:user).permit(Registration::USER_ATTRIBUTES)
    end
  end
end
