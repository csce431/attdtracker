class CoursesController < ApplicationController
    #skip_before_action :verify_authenticity_token
    #before_action :require_teacher_login

    def index
        @teacher = Teacher.find(params[:teacher_id])
        @courses = @teacher.courses.order(:year).reverse_order.order(:season)
        @isAdmin = Admin.pluck(:email).include? session[:email]

        @all_seasons = better_distinct_season(@courses.order(:year).reverse_order)
        @all_years = better_distinct_year(@courses.order(:season)).sort
        @all_years = @all_years.map { |str| str.to_s }

        @current_seasons = params[:seasons]
        @current_years = params[:years]
        if (!params[:seasons].nil? and !params[:years].nil?)
            @current_seasons = params[:seasons].keys
            @current_years = params[:years].keys
        elsif !params[:seasons].nil?
            @current_seasons = params[:seasons].keys
            @current_years = @all_years
        elsif !params[:years].nil?
            @current_seasons = @all_seasons
            @current_years = params[:years].keys
        else
            @current_seasons = @all_seasons
            @current_years = @all_years
        end
        @courses = @teacher.courses.where(year: @current_years, season: @current_seasons)
    end

    def import
        @course = Course.find(params[:id])
        @students_in_course = @course.students.all
        @teacher = @course.teacher_id

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
                end
            end
        end

        redirect_to teacher_course_path(@teacher, @course)
    end
    
    def new
        @course = Course.new
        @teacher = Teacher.find(params[:teacher_id])
    end
    
    def edit
        @course = Course.find(params[:id])
        @teacher = @course.teacher_id
    end
    
    def show
        @course = Course.find(params[:id])
        @students = @course.students.order(:lname)
        @teacher = @course.teacher_id
    end
    
    def create
        @course = Course.new(course_params)
        @teacher = Teacher.find(params[:teacher_id])
 
        if @course.save
            @teacher.courses << @course
            
            redirect_to teacher_courses_path(@teacher)
        else
            render 'new'
        end
    end
    
    def update
        @course = Course.find(params[:id])
        @teacher = @course.teacher_id
 
        if @course.update(course_params)
            redirect_to teacher_courses_path(@teacher)
        else
            render 'edit'
        end
    end

    def destroy
        @course = Course.find(params[:id])
        @course.destroy
        @teacher = Teacher.find(params[:teacher_id])
        
        redirect_to teacher_path(@teacher)
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

        def require_student_login
            unless session[:student_logged_in] == true
                render 'no_auth'
            end
        end

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
