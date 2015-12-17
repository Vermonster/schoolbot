module API
  class StudentsController < BaseController
    include TokenAuthenticated

    def index
      respond_with current_user.student_labels.includes(
        :school,
        student: { current_bus_assignment: { bus: :recent_locations } }
      )
    end

    def create
      student_label = current_user.student_labels.create(create_params)

      respond_with student_label, location: nil
    end

    def update
      student_label = current_user.student_labels.find(params[:id])
      student_label.update(update_params)

      respond_with student_label
    end

    private

    def create_params
      params.require(:student).permit(:digest, :nickname, :school_id)
    end

    def update_params
      create_params.except(:digest)
    end
  end
end
