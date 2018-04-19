module API
  module V0
    class AssignmentsController < BaseController
      include DistrictAuthenticated

      def show
        respond_with Student.find_by!(digest: params[:id])
      end

      def create
        validate_assignments_params!
        ImportAssignmentsJob.perform_later(
          district: authenticated_district,
          data: request.raw_post
        )
        head :accepted
      end

      private

      ASSIGNMENT_KEYS = %w[sha bus_identifier]

      def validate_assignments_params!
        unless params[:assignments].is_a?(Array)
          raise ActionController::ParameterMissing, :assignments
        end

        params[:assignments].each do |assignment_params|
          validate_assignment_params!(assignment_params)
        end
      end

      def validate_assignment_params!(assignment_params)
        unless assignment_params.keys == ASSIGNMENT_KEYS
          raise ActionController::UnpermittedParameters, assignment_params.keys
        end

        ASSIGNMENT_KEYS.each do |key|
          value = assignment_params[key]
          unless value.nil? || value.is_a?(String)
            raise ActionController::UnpermittedParameters, [value.inspect]
          end
        end
      end
    end
  end
end
