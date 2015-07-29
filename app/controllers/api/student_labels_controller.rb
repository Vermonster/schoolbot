module API
  class StudentLabelsController < BaseController
    include TokenAuthenticated

    def index
      respond_with current_user.student_labels
    end
  end
end
