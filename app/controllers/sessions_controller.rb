class SessionsController < ApplicationController
    def index
        if !Admin.where(email: session[:email]).first.nil?
            session[:admin_logged_in] = true
            @admin = Admin.where(email: session[:email]).first
            # @admin = Admin.where(email: "racheljee1@tamu.edu").first
            redirect_to teachers_path
        elsif session[:email] == "rdj772@tamu.edu"
            session[:admin_logged_in] = true
            @admin = create_admin(session[:fname], session[:lname], session[:email])
            redirect_to teachers_path
        elsif !Teacher.where(email: session[:email]).first.nil?
            session[:teacher_logged_in] = true
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

        # session[:loggedin] = true
        session[:fname] = access_token.info.first_name
        session[:lname] = access_token.info.last_name
        session[:email] = access_token.info.email
        session[:picture] = access_token.info.image
        # session[:token] = refresh_token # or do I use @user.google_refresh_token
        #puts user.id

        # if access_token.info.email == "racheljee1@tamu.edu"
        #     @user = Student.where(email: "racheljee1@tamu.edu").first
        #     @user.google_refresh_token = refresh_token
        #     render 'admin'
        #     # render new_student_teacher_path
        #     render "teachers/index"
        # else
        #     @user = create_from_omniauth(access_token) 
        #     @user.google_refresh_token = refresh_token if refresh_token.present?
            # redirect_to students/show.html.erb
        redirect_to root_path
        # end
        
        # look thru teacher database, if finds a matching email, (check authenticity?), redirect to teacher/show
        # else create student, redirect to student view page
    end

    # def authenticate
    #     if session[:token] == @user.google_refresh_token
            
    #     end
    # end

    def destroy
        session.clear
        
        redirect_to root_path
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
        #data = access_token.info
        #user = User.where(email: data['email']).first
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
        if Student.where(email: email).first.nil?
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

