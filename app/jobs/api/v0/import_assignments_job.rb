module API
  module V0
    class ImportAssignmentsJob < ActiveJob::Base
      queue_as :imports

      def perform(district:, data:)
        @district = district
        @assignments = JSON.parse(data, symbolize_names: true)[:assignments]
        return if @assignments.empty?

        ActiveRecord::Base.transaction do
          update_student_assignments!
          unassign_missing_students!
        end
      end

      private

      def assign_student_to_bus(student_digest:, bus_identifier:)
        student = @district.students.find_or_create_by!(digest: student_digest)
        bus = if bus_identifier.present?
          @district.buses.find_or_create_by!(identifier: bus_identifier)
        end
        assignment = student.current_bus_assignment

        if assignment.present? && assignment.bus_id == bus.try(:id)
          assignment.touch
        else
          student.bus_assignments.create!(bus: bus)
        end
      end

      def unassign_missing_students!
        digests = @assignments.map { |assignment| assignment[:sha] }

        @district.students.where.not(digest: digests).find_each do |student|
          student.bus_assignments.create!(bus: nil)
        end
      end

      def update_student_assignments!
        @assignments.each do |assignment|
          begin
            assign_student_to_bus(
              student_digest: assignment[:sha],
              bus_identifier: assignment[:bus_identifier]
            )
          rescue ActiveModel::StrictValidationFailed
            Airbrake.notify($ERROR_INFO, parameters: { district: @district })
          end
        end
      end
    end
  end
end
