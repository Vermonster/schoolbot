module API
  class StudentsController < BaseController
    include TokenAuthenticated

    def index
      respond_with current_user.student_labels
    end

    def create
      student_label = current_user.student_labels.create(
        nickname: student_params[:nickname],
        school: School.find_by(id: student_params[:school_id]),
        student: Student.find_by(digest: student_params[:digest])
      )

      respond_with student_label, location: nil
    end

    private

    def student_params
      params.require(:student)
        .except(:bus_id)
        .permit(:digest, :nickname, :school_id)
    end
  end
end
