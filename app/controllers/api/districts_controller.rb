module API
  class DistrictsController < BaseController
    def show
      respond_with District.find_by!(slug: request.subdomains.first)
    end
  end
end
