module API
  class RegistrationsController < BaseController
    def create
      registration = Registration.new(
        district: current_district,
        attributes: registration_params
      )
      registration.save

      respond_with registration, location: nil
    end

    private

    def registration_params
      params.require(:registration)
        .except(:latitude, :longitude)
        .permit(Registration::ATTRIBUTES)
    end
  end
end
