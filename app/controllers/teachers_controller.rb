class TeachersController < ApplicationController
    #before_action :require_admin_login, only: [:index]
    #before_action :require_teacher_login
    
    def index
        @teachers = Teacher.order(:lname)
        
        @all_departments = distinct_department(Teacher.order(:department))
        
        @current_departments = params[:departments]
        if params[:departments].nil?
            @current_departments = @all_departments
        else
            @current_departments = params[:departments].keys
        end
        @teachers = Teacher.where(department: @current_departments)
    end
    
    def new
        @teacher = Teacher.new
    end

    def create
        @teacher = Teacher.new(teacher_params)
        @teacher.department = @teacher.department.upcase
        
        if @teacher.save
            redirect_to teachers_path
        else
            render 'new'
        end
    end
    
    def show
        @teacher = Teacher.find(params[:id])
        redirect_to teacher_courses_path(@teacher)
    end 
    
    def edit
        @teacher = Teacher.find(params[:id])
        @isTeacher = Teacher.pluck(:email).include? session[:email]
        @isAdmin = Admin.pluck(:email).include? session[:email]
    end
    
    def update
        @teacher = Teacher.find(params[:id])
 
        if @teacher.update(teacher_params)
            redirect_to teachers_path
        else
            render 'edit'
        end
    end
    
    def destroy
        @teacher = Teacher.find(params[:id])
        @teacher.destroy
 
        redirect_to teachers_path
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
        ##distinct doesn't work on heroku so we created our own distinct
        def distinct_department(teachers)
            distinct_departments = Array.new
            for teacher in teachers.each do
                exist = false
                for department in distinct_departments do
                    if teacher.department == department
                        exist = true
                    end
                end
                if !exist
                    distinct_departments.push(teacher.department)
                end
            end
            distinct_departments
        end
        
        def distinct_season(courses)
            distinct_seasons = Array.new
            for course in courses.each do
                exist = false
                for season in distinct_seasons do
                    if course.season == season
                        exist = true
                    end
                end
                if !exist
                    distinct_seasons.push(course.season)
                end
            end
            distinct_seasons
        end
        
        def distinct_year(courses)
            distinct_years = Array.new
            for course in courses.each do
                exist = false
                for year in distinct_years do
                    if course.year == year
                        exist = true
                    end
                end
                if !exist
                    distinct_years.push(course.year)
                end
            end
            distinct_years
        end
        
        def teacher_params
            params.require(:teacher).permit(:fname, :mname, :lname, :email, :department)
        end
end
