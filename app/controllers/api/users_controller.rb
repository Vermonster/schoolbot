module API
  class UsersController < BaseController
    include TokenAuthenticated

    def show
      respond_with current_user
    end

    def update
      profile_update = ProfileUpdate.new(
        user: current_user,
        attributes: user_params
      )
      profile_update.save

      respond_with profile_update, json: profile_update
    end

    private

    def user_params
      params.require(:user).permit(ProfileUpdate::ATTRIBUTES)
    end
  end
end
