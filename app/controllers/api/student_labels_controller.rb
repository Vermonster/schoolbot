module API
  class StudentLabelsController < BaseController
    def index
      respond_with current_user.student_labels
    end
  end
end
