class AdminsController < ApplicationController
    def index
        if session[:admin_logged_in] != true
            flash[:alert] = "ERROR: You must be logged in as an admin to access that page!"
            session[:login] = flash[:alert]
        #    redirect_to root_path
        end
        @admins = Admin.all
        @isStudent = Student.pluck(:email).include? session[:email] 
        #@isTeacher = Teacher.email.include? session[:email]
    end
    
    def new
        @admin = Admin.new
    end
    
    def create
        @admin = Admin.new(admin_params)
        
        if @admin.save
            redirect_to admins_path
        else
            render 'new'
        end
    end
    
    def destroy
        @admin = Admin.find(params[:id])
        @admin.destroy
 
        redirect_to admins_path
    end

    private
        def admin_params
            params.require(:admin).permit(:fname, :mname, :lname, :email)
        end
end
