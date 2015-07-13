module API
  class DistrictsController < BaseController
    skip_before_action :authenticate_user!

    def show
      respond_with District.find_by!(slug: request.subdomain)
    end
  end
end
