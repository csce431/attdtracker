class SessionsController < ApplicationController
    skip_before_action :session_expiration, only: [:index, :googleAuth, :destroy]

    def index
        if session[:email] == "racheljee1@tamu.edu" #!Admin.where(email: session[:email]).first.nil?
            session[:admin_logged_in] = true
            session[:teacher_logged_in] = true
            session[:student_logged_in] = true
            @admin = Admin.where(email: session[:email]).first
            @admin = create_admin(session[:fname], session[:lname], session[:email]) # to add an admin for the first time
            redirect_to admins_path
        elsif !Teacher.where(email: session[:email]).first.nil?
            session[:teacher_logged_in] = true
            session[:student_logged_in] = true
            @teacher = Teacher.where(email: session[:email]).first
            redirect_to teacher_path(@teacher)
        elsif session[:email].to_s.end_with?("@tamu.edu") # if not an admin or teacher but has tamu email, then student
            session[:student_logged_in] = true
            @student = create_from_omniauth(session[:fname],session[:lname],session[:email],session[:picture])
            redirect_to student_path(@student)
        end
    end
    
    def googleAuth
        session.clear
        access_token = request.env["omniauth.auth"]
        refresh_token = access_token.credentials.refresh_token

        session[:fname] = access_token.info.first_name
        session[:lname] = access_token.info.last_name
        session[:email] = access_token.info.email
        session[:picture] = access_token.info.image
        t = Time.now + 30.minutes
        session[:expires_at] = t.to_i 
        # session[:token] = refresh_token # or use @user.google_refresh_token

        redirect_to root_path
    end

    def destroy
        # session.clear
        session.delete(:fname)
        session.delete(:lname)
        session.delete(:email)
        session.delete(:picture)
        session.delete(:admin_logged_in)
        session.delete(:teacher_logged_in)
        session.delete(:student_logged_in)
        # session.delete(:expires_at)
        session.delete(:alert)

        redirect_to root_path
        session[:alert] = flash[:alert]
    end

private
    def exist_email(email)
        ret = false
        for student in Student.all do
            if email == student.email
                ret = true
            end
        end
        ret
    end

    def create_from_omniauth(fname, lname, email, pic)
        # Creates a new user only if it doesn't exist
        if Student.where(email: email).first.nil?
            @newstudent = Student.new
            @newstudent.fname = fname
            @newstudent.lname = lname
            @newstudent.email = email
            @newstudent.picture = pic
            @newstudent.save!
        else
            @newstudent = Student.where(email: email).first 
        end
        @newstudent
    end

    def create_admin(fname, lname, email)
        if Admin.where(email: email).first.nil?
            @newadmin = Admin.new
            @newadmin.fname = fname
            @newadmin.lname = lname
            @newadmin.email = email
            @newadmin.save!
        else
            @newadmin = Admin.where(email: email).first
        end
        @newadmin
    end
end

