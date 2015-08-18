module API
  class UsersController < BaseController
    include TokenAuthenticated

    def show
      respond_with current_user
    end
  end
end
