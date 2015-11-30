module API
  class PasswordResetsController < BaseController
    def show
      respond_with existing_reset
    end

    def create
      new_reset = PasswordReset.init(reset_email, district: current_district)
      new_reset.enable

      respond_with new_reset, location: nil
    end

    def update
      existing_reset.confirm(reset_params)

      respond_with existing_reset
    end

    private

    def existing_reset
      @_existing_reset ||=
        PasswordReset.find(params[:id], district: current_district)
    end

    def reset_email
      params.require(:password_reset).fetch(:email)
    end

    def reset_token
      params.require(:password_reset).fetch(:id)
    end

    def reset_params
      params.require(:password_reset).permit(PasswordReset::ATTRIBUTES)
    end
  end
end
