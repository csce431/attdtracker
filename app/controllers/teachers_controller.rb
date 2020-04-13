class TeachersController < ApplicationController
    before_action :require_admin_login, only: [:index]
    before_action :require_teacher_login
    
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
        # @courses = @teacher.courses.order(:year).reverse_order.order(:season)
        
        redirect_to teacher_courses_path(@teacher)

        # @all_seasons = distinct_season(@courses.order(:year).reverse_order)
        # @all_years = distinct_year(@courses.order(:season)).sort
        # @all_years = @all_years.map { |str| str.to_s }

        # @current_seasons = params[:seasons]
        # @current_years = params[:years]
        # if (!params[:seasons].nil? and !params[:years].nil?)
        #     @courses = @teacher.courses.where(year: @current_years.keys, season: @current_seasons.keys) 
        # elsif !params[:seasons].nil?
        #     @current_seasons = params[:seasons].keys
        #     @current_years = @all_years
        #     @courses = @teacher.courses.where(season: @current_seasons.keys)
        # elsif !params[:years].nil?
        #     @current_seasons = @all_seasons
        #     @current_years = params[:years].keys
        #     @courses = @teacher.courses.where(year: @current_years.keys)
        # else
        #     @current_seasons = @all_seasons
        #     @current_years = @all_years
        # end
        # @courses = Course.where(year: @current_years, season: @current_seasons)
        # @courses = Course.order(:year).reverse_order

        #######

        # @all_seasons = @courses.distinct.pluck(:season)
        # @all_years = @courses.distinct.pluck(:year)
        # @all_years = @all_years.map { |str| str.to_s }
        
        # if (params[:seasons].nil? and params[:years].nil?)
        #     @current_seasons = @all_seasons
        #     @current_years = @all_years
        # elsif params[:seasons].nil?
        #     @current_seasons = @all_seasons
        #     @current_years = params[:years].keys
        # elsif params[:years].nil?
        #     @current_seasons = params[:seasons].keys
        #     @current_years = @all_years
        # else
        #     @current_seasons = params[:seasons].keys
        #     @current_years = params[:years].keys
        # end

        # @courses = Course.where(year: @current_years, season: @current_seasons)
    end 
    
    def edit
        @teacher = Teacher.find(params[:id])
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
