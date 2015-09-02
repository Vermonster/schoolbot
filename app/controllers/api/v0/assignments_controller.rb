module API
  module V0
    class AssignmentsController < BaseController
      include DistrictAuthenticated

      def show
        respond_with Student.find_by!(digest: params[:id])
      end

      def create
        ImportAssignmentsJob.perform_later(
          district: authenticated_district,
          assignments: assignments_params
        )
        head :accepted
      end

      private

      def assignments_params
        params.require(:assignments)
        permitted_params = params.permit(assignments: [:sha, :bus_identifier])
        if params[:assignments] != permitted_params[:assignments]
          fail ActionController::UnpermittedParameters, []
        end
        permitted_params[:assignments]
      end
    end
  end
end
