module API
  module V0
    class StudentSerializer < ActiveModel::Serializer
      self.root = 'assignment'

      attributes :sha, :bus_identifier

      def sha
        object.digest
      end

      def bus_identifier
        object.current_bus_assignment.try(:bus).try(:identifier)
      end
    end
  end
end
