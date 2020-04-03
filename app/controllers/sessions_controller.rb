class SessionsController < ApplicationController
    def index
        if session[:email] == ""
            redirect_to root_path
            # render 'index'
        elsif session[:email] == "racheljee1@tamu.edu"
            @admin = Student.where(email: "racheljee1@tamu.edu").first
            # redirect_to new_student_teacher_path(@admin) # teacher/new
            # redirect_to student_teacher_path(@admin)
            redirect_to teacher_index2_path
        elsif session[:email] == "rdj772@tamu.edu"
            @teacher = Teacher.where(email: "rdj772@tamu.edu").first
            redirect_to teacher_path(@teacher)
        else
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

    def admin
        @teacher = Teacher.new
    end
    # def authenticate
    #     if session[:token] == @user.google_refresh_token
            
    #     end
    # end

    def destroy
        session.delete :fname
        session.delete :lname
        session.delete :email 
        
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
end

