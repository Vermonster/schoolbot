module API
  class DistrictsController < BaseController
    def show
      respond_with District.find_by!(slug: request.subdomain)
    end
  end
end
