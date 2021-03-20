class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :session_expiration
  after_action :session_activity
 
  private
    def session_expiration
      if session[:expires_at].to_i < Time.now.to_i
        flash[:alert] = "WARNING: You were logged out for inactivity. Please sign in again."
        redirect_to logout_path #, alert: "ERROR: You are being timed out for inactivity. Please sign in again."
      end
    end

    def session_activity
      t = Time.now + 30.minutes
      session[:expires_at] = t.to_i
    end
end
