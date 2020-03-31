class TeachersController < ApplicationController
    def index
        #admin
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
 
        if @teacher.save
            redirect_to teachers_path
        else
            render 'new'
        end
    end
    
    def show
        #teacher/:id/courses
        @teacher = Teacher.find(params[:id])
        @courses = @teacher.courses.order(:year).reverse_order.order(:season)
        
        @all_seasons = distinct_season(Course.order(:year).reverse_order)
        @all_years = distinct_year(Course.order(:season)).sort
        
        @current_seasons = params[:seasons]
        @current_years = params[:years]
        if (!params[:seasons].nil? and !params[:years].nil?)
            @courses = Course.where(year: @current_years.keys, season: @current_seasons.keys) 
        elsif !params[:seasons].nil?
            @courses = Course.where(season: @current_seasons.keys)
        elsif !params[:years].nil?
            @courses = Course.where(year: @current_years.keys)
        end
    end 
    
    def edit
    end
    
    def update
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
            params.require(:teacher).permit(:fname, :mname, :lname, :department)
        end
end
