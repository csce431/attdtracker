class SessionsController < ApplicationController
    def googleAuth
        session.clear
        # Get access tokens from the google server
        access_token = request.env["omniauth.auth"]
        em = access_token["info"]["email"]
        puts access_token
        #user = User.find_by email: access_token["info"]["email"]
        #puts User.find_by email: access_token["info"]["email"]
        #user = User.create_from_omniauth(access_token)
        #user.save! 

        session[:user] = em
        #puts user.id

        redirect_to root_path
    end
    def destroy
        session.delete :user
        
        redirect_to root_path
    end
end