class SessionsController < ApplicationController
    def googleAuth
        session.clear
        # Get access tokens from the google server
        access_token = request.env["omniauth.auth"]
        na = access_token["info"]["name"]
        em = access_token["info"]["email"]
        #puts access_token
        #puts User.find_by email: access_token["info"]["email"]
        user = Student.create_from_omniauth(access_token)
        #user = Student.find_by email: access_token["info"]["email"]

        refresh_token = access_token.credentials.refresh_token
        user.google_refresh_token = refresh_token if refresh_token.present?
        #user.google_token = access_token 

        user.save! 
        
        session[:name] = na
        session[:email] = em
        session[:user] = user.lname
        #session[:token] = access_token # putting token in session gives cookie overflow
        #puts user.id
        
        # look thru all user database, if role of email is instructor, redirect to path of instructor tab (remove tab)
        # if role is student, redirect to student view page

        if em == "racheljee1@tamu.edu"
            @student = Student.where(email: "racheljee1@tamu.edu").first
            @student.role = 0
            #redirect to an admin page, need to look thru database to assign roles to teachers (1)
        end
        #if (Student.find_by email: "racheljee1@tamu.edu").role == 0
        session[:role] = Student.where(email: "racheljee1@tamu.edu").first).role
        if (Student.where(email: "racheljee1@tamu.edu").first).role == 0
            render 'admin'
        # elsif (Student.find_by email: em).role == 1
        #     #redirect to instructor home page
        # elsif (Student.find_by email: em).role == 2
        #     #redirect to student profile page
        else
            redirect_to root_path
        end
        # redirect_to root_path
    end
    def destroy
        session.delete :name
        session.delete :email 
        
        redirect_to root_path
    end
end