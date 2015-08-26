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
  end
end
