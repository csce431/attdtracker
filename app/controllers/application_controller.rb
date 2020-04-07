class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :require_admin_login
  before_action :require_teacher_login
  before_action :require_student_login
 
  private
  # require user to log in before accessing any url
  # def require_admin_login
  #   unless session[:admin_logged_in] == true
  #     flash[:error] = "You must be logged in as an admin to access this section"
  #     redirect_to root_path # halts request cycle
  #   end
  # end

  def require_teacher_login
    unless session[:teacher_logged_in] == true
      flash[:error] = "You must be logged in as a teacher to access this section"
      redirect_to root_path # halts request cycle
    end
  end

  def require_student_login
    unless session[:student_logged_in] == true
      flash[:error] = "You must be logged in as a student to access this section"
      redirect_to root_path # halts request cycle
    end
  end
end
