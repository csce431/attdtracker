class AdminsController < ApplicationController
    #before_action :require_admin_login

    def index
        @admins = Admin.all
        @isStudent = Student.pluck(:email).include? session[:email] 
        if @isStudent
            @student = Student.where(email: session[:email]).first
        else
            @student = Student.new
            @student.id = 0
        end
        @isTeacher = Teacher.pluck(:email).include? session[:email]
        if @isTeacher
            @teacher = Teacher.where(email: session[:email]).first
        else
            @teacher = Teacher.new
            @teacher.id = 0
        end
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

    def show
        @student = Student.new
    end
    
    def edit
        @admin = Admin.find(params[:id])
    end

    def update
        @admin = Admin.find(params[:id])
 
        if @admin.update(admin_params)
            redirect_to admins_path
        else
            render 'edit'
        end
    end

    def destroy
        @admin = Admin.find(params[:id])
        @admin.destroy
 
        redirect_to admins_path
    end

    private
        def require_admin_login
            unless session[:admin_logged_in] == true
                render 'no_auth'
            end
        end
        def require_teacher_login
            unless session[:teacher_logged_in] == true
                render 'no_auth'
            end
        end
        def admin_params
            params.require(:admin).permit(:fname, :mname, :lname, :email)
        end
end
