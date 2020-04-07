class TeachersController < ApplicationController
    def index
        #admin
        if session[:admin_logged_in] != true
            flash[:alert] = "ERROR: You must be logged in as an admin to access that page!"
            session[:login] = flash[:alert]
            redirect_to root_path
        end
        @teachers = Teacher.order(:lname)
        
        @all_departments = distinct_department(Teacher.order(:department))
        
        @current_departments = params[:departments]
        if !params[:departments].nil?
            @teachers = Teacher.where(department: @current_departments.keys) 
        end
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
        @courses = @teacher.courses.order(:year).reverse_order.order(:season)
        
        @all_seasons = distinct_season(@courses.order(:year).reverse_order)
        @all_years = distinct_year(@courses.order(:season)).sort
        
        @current_seasons = params[:seasons]
        @current_years = params[:years]
        if (!params[:seasons].nil? and !params[:years].nil?)
            @courses = @teacher.courses.where(year: @current_years.keys, season: @current_seasons.keys) 
        elsif !params[:seasons].nil?
            @courses = @teacher.courses.where(season: @current_seasons.keys)
        elsif !params[:years].nil?
            @courses = @teacher.courses.where(year: @current_years.keys)
        end
    end 
    
    def edit
        @teacher = Teacher.find(params[:id])
    end
    
    def update
        @teacher = Teacher.find(params[:id])
 
        if @teacher.update(teacher_params)
            redirect_to teacher_path(@teacher)
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
