class UsersController < ApplicationController
    def index
        @users = User.all
    end
    
    def new
        @user = User.new
    end
    
    def edit
        @user = User.find(params[:id])
        @course = Course.find(params[:course_id])
    end
    
    def show
        @user = User.find(params[:id])
        @courses = @user.courses.all
        @email = @user.email
        if(@courses.first.cards.where(email: @user.email).first)
            @card = @courses.first.cards.where(email: @user.email).first.code
        else
            @card = "N/A"
        end
    end
    
    def create
        @user = User.new(user_params)
        @course = Course.find(params[:course_id])
        
        if exist_email(@user.email)
        begin
            @existuser = User.where(email: @user.email).first
            if !email_in_course(@course, @user.email) 
                @existuser.courses << @course
            end
            redirect_to course_path(@existuser.courses.last)
        end
        else
            if @user.save
            begin
                @user.courses << @course
                redirect_to course_path(@course)
            end
            else
                render 'new'
            end
        end
    end
    
    def update
        @user = User.find(params[:id])
 
        if @user.update(user_params)
            redirect_to @user
        else
            render 'edit'
        end
    end
    
    def destroy
        @user = User.find(params[:id])
        @course = Course.find(params[:course_id])
        @course.users.destroy(User.find(params[:id]))
 
        redirect_to courses_path(@course)
    end 
    
    private
        def exist_email(email)
           ret = false
           for user in User.all do
                if email == user.email
                    ret = true
                end
           end
           ret
        end
        
        def email_in_course(course, email)
            ret = false
            for user in course.users do
                if user.email == email
                    ret = true
                end
            end
            ret            
        end
        
        def user_params
            params.require(:user).permit(:fname, :mname, :lname, :prefname, :uin, :email)
        end
end
