module API
  module V0
    class AssignmentsController < BaseController
      include DistrictAuthenticated

      def show
        respond_with(
          Student.find_by!(digest: params[:id]),
          namespace: ::API::V0 # FIXME: Why is this needed?
        )
      end

      def create
        ImportAssignmentsJob.perform_later(
          district: current_district,
          assignments: assignments_params
        )
        head :accepted
      end

      private

      def assignments_params
        params.require(:assignments)
        params.permit(assignments: [:sha, :bus_identifier])[:assignments]
      end
    end
  end
end
