module API
  class StudentsController < BaseController
    include TokenAuthenticated

    def index
      respond_with current_user.students
    end
  end
end
