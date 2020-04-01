class SessionsController < ApplicationController
    def index
        # was used to check if my email was being created
        # if !Student.where(email: "racheljee1@tamu.edu").first.nil?
        #     @student = Student.where(email: "racheljee1@tamu.edu").first
        # elsif !Student.where(email: "rdj772@tamu.edu").first.nil?
        #     @student = Student.where(email: "rdj772@tamu.edu").first
        # end
    end
    
    def googleAuth
        session.clear
        access_token = request.env["omniauth.auth"]
        @user = create_from_omniauth(access_token) # this will have to go in diff line maybe 
        #user = Student.find_by email: access_token["info"]["email"]

        refresh_token = access_token.credentials.refresh_token
        @user.google_refresh_token = refresh_token if refresh_token.present?
        # @user.google_token = access_token 
        
        session[:name] = @user.fname
        # session[:email] = @user.email
        session[:token] = @user.google_refresh_token # or do I use @user.google_refresh_token
        #puts user.id
        
        # look thru teacher database, if finds a matching email, (check authenticity?), redirect to teacher/show
        # else create student, redirect to student view page

        if @user.email == "racheljee1@tamu.edu"
            @student = Student.where(email: "racheljee1@tamu.edu").first
            #@student.role = 0
            render 'admin'
        else

        # if Teacher.where(email: @em).first.nil?
        #     @teacher = Teacher.where(email: @em).first
        #     # redirect or render to teacher/show
        # else # email belongs to student
            
        # end
            redirect_to root_path
        end
    end

    def admin
        @teacher = Teacher.new
    end
    # def authenticate
    #     if session[:token] == @user.google_refresh_token
            
    #     end
    # end

    def destroy
        session.delete :name
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

    def create_from_omniauth(access_token)
        #data = access_token.info
        #user = User.where(email: data['email']).first
        # Creates a new user only if it doesn't exist
    	if !exist_email(access_token.info.email)
            @newstudent = Student.new
            @newstudent.fname = access_token.info.first_name
            @newstudent.lname = access_token.info.last_name
            @newstudent.email = access_token.info.email
            @newstudent.picture = access_token.info.image
            @newstudent.save!
        else
            @newstudent = Student.where(email: access_token.info.email).first 
        end
        @newstudent
    end
end

