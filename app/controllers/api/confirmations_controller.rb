module API
  class ConfirmationsController < BaseController
    def create
      confirmation = Confirmation.new(district: current_district, token: token)
      confirmation.save

      respond_with confirmation, location: nil
    end

    private

    def token
      params.require(:confirmation).fetch(:token)
    end
  end
end
