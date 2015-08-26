module API
  class BaseController < ActionController::Base
    respond_to :json

    rescue_from ActiveRecord::RecordNotFound do
      head :not_found
    end

    rescue_from ActionController::ParameterMissing do
      head :unprocessable_entity
    end

    rescue_from ActionController::UnpermittedParameters do
      head :unprocessable_entity
    end

    private

    def current_district
      @_current_district ||= District.find_by!(slug: request.subdomains.first)
    end
  end
end
