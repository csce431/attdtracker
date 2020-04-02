class CoursesController < ApplicationController

    skip_before_action :verify_authenticity_token 

    def index
        @courses = Course.order(:year).reverse_order
        
        @all_seasons = @courses.distinct.pluck(:season)
        @all_years = @courses.distinct.pluck(:year)
        @all_years = @all_years.map { |str| str.to_s }
        
        #@movies = Movie.order(@sort_by)
        #@sort_by = params[:sort_by]
        #@current_ratings = params[:ratings] 
        
        if (params[:seasons].nil? and params[:years].nil?)
            @current_seasons = @all_seasons
            @current_years = @all_years
        elsif params[:seasons].nil?
            @current_seasons = @all_seasons
            @current_years = params[:years].keys
        elsif params[:years].nil?
            @current_seasons = params[:seasons].keys
            @current_years = @all_years
        else
            @current_seasons = params[:seasons].keys
            @current_years = params[:years].keys
        end

        @courses = Course.where(year: @current_years, season: @current_seasons) 
    end

    def import
        @course = Course.find(params[:id])
        @students_in_course = @course.students.all

        tempFile = params['enrollment']
        csv = CSV.read(tempFile.path, :headers => true)

        for student in csv do
            # create new student
            #@newstudent = @students_in_course.new
            @newstudent = Student.new
            @newstudent.email = student['email']

            # fill in student's params
            @newstudent.fname = student['First']
            @newstudent.mname = student['Middle']
            @newstudent.lname = student['Last']
            
            # check if imported email exists
            if exist_email_in_course(student['email'], @course)
                # do nothing (email already exists in course)
                # next
            elsif exist_email(student['email'])
                # email exists
                @newstudent = Student.where(email: @newstudent.email).first
                @newstudent.courses << @course
            else
                # email doesnt exist
                if @newstudent.save
                    @newstudent.courses << @course
                    #@students_in_course << @newstudent
                    #@course << @newstudent
                end
            end
        end

        redirect_to course_path(@course)
    end
    
    def new
        @course = Course.new
    end
    
    def edit
        @course = Course.find(params[:id])
    end
    
    def show
        @course = Course.find(params[:id])
        #@students = @course.students.all
        @students = @course.students.order(:lname)
    end
    
    def create
        @course = Course.new(course_params)
 
        if @course.save
            redirect_to courses_path
        else
            render 'new'
        end
    end
    
    def update
        @course = Course.find(params[:id])
 
        if @course.update(course_params)
            redirect_to @course
        else
            render 'edit'
        end
    end
    
    def destroy
        @course = Course.find(params[:id])
        @course.destroy
 
        redirect_to courses_path
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

        def exist_email_in_course(email, course)
            ret = false
            for student in course.students.all do
                if email == student.email
                    ret = true
                end
            end
            ret
        end

        def course_params
            params.require(:course).permit(:name, :number, :section, :year, :season)
        end
end
