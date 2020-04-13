class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :require_admin_login
  before_action :session_expiration
  after_action :session_activity
 
  private
    def session_expiration
      if session[:expires_at].to_i < Time.now.to_i
        redirect_to logout_path #, alert: "ERROR: You are being timed out for inactivity. Please sign in again."
        flash[:alert] = "ERROR: You are being timed out for inactivity. Please sign in again."
      end
    end

    def session_activity
      t = Time.now + 30.minutes
      session[:expires_at] = t.to_i
    end
  # # require user to log in before accessing any url
  # def require_admin_login
  #   unless session[:admin_logged_in] == true
  #     flash[:error] = "You must be logged in as an admin to access this section"
  #     redirect_to root_path # halts request cycle
  #   end
  # end
end
