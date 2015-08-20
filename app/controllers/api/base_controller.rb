module API
  class BaseController < ActionController::Base
    respond_to :json
    self.responder = BaseResponder

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
