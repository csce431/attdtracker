class CoursesController < ApplicationController

    skip_before_action :verify_authenticity_token 

    def index
        @courses = Course.order(:year).reverse_order.order(:season)
        @teacher = Teacher.find(params[:teacher_id])
        
        @all_seasons = better_distinct_season(Course.order(:year).reverse_order)
        @all_years = better_distinct_year(Course.order(:season)).sort
        
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
            if exist_email_in_course(student['email'],@course)
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
        @teacher = Teacher.find(params[:teacher_id])
    end
    
    def show
        @course = Course.find(params[:id])
        @students = @course.students.order(:lname)
        @teacher = Teacher.find(params[:teacher_id])
    end
    
    def create
        @course = Course.new(course_params)
        @teacher = Teacher.find(params[:teacher_id])
 
        if @course.save
            @teacher.courses << @course
            
            redirect_to teacher_path(@teacher)
        else
            render 'new'
        end
    end
    
    def update
        @course = Course.find(params[:id])
        @teacher = Teacher.find(params[:teacher_id])
 
        if @course.update(course_params)
            redirect_to teacher_courses_path(@teacher)
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

        #distinct doesn't work on heroku so we created our own distinct
        def better_distinct_season(courses)
            new_courses_seasons = Array.new
            for course in courses.each do
                exist = false
                for season in new_courses_seasons do
                    if course.season == season
                        exist = true
                    end
                end
                if !exist
                    new_courses_seasons.push(course.season)
                end
            end
            new_courses_seasons
        end
        
        def better_distinct_year(courses)
            new_courses_years = Array.new
            for course in courses.each do
                exist = false
                for year in new_courses_years do
                    if course.year == year
                        exist = true
                    end
                end
                if !exist
                    new_courses_years.push(course.year)
                end
            end
            new_courses_years
        end

        def course_params
            params.require(:course).permit(:name, :number, :section, :year, :season)
        end
end
