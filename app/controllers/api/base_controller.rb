module API
  class BaseController < ActionController::Base
    respond_to :json

    rescue_from ActiveRecord::RecordNotFound do
      head :not_found
    end
  end
end
