class StudentsController < ApplicationController
    before_action :require_teacher_login, only: [:new, :create, :destroy]
    before_action :require_student_login

    def index
        @students = Student.all
    end
    
    def new
        @student = Student.new
    end
    
    def edit
        @student = Student.find(params[:id])
        @coursespage = params[:course_id].present?
        @isnotstudent = (Teacher.pluck(:email).include? session[:email]) || (Admin.pluck(:email).include? session[:email])
        if params[:course_id]
            @course = Course.find(params[:course_id])
        else
            @course = Course.new
            @course.id = 0
        end

        if @student.mname.nil?
            @student.mname = ""
        end
    end

    def studentEdit
        @student = Student.find(params[:student_id])
        if @student.mname.nil?
            @student.mname = ""
        end
    end
    
    def show
        @student = Student.find(params[:id])
        @courses = @student.courses.all
        
        #dictates which path to take in html
        @coursespage = params[:course_id].present?
        @isTeacher = Teacher.pluck(:email).include? session[:email]
        @isAdmin = (Admin.pluck(:email).include? session[:email])
        @isnotstudent = (@isTeacher) || (Admin.pluck(:email).include? session[:email])
        
        #prevents errors
        if params[:course_id].present?
            @course = Course.find(params[:course_id])
        else
            @course = Course.new
            @course.id = 0
        end

        if(@isTeacher)
            @teacher = Teacher.where(email: session[:email]).first
        else
            @teacher = Teacher.new
            @teacher.id = 0
        end
        @isAdmin = Admin.pluck(:email).include? session[:email]
    end
    
    def create
        @student = Student.new(student_params)
        
        if !params[:course_id]
            # @student.save!
            if @student.save
                redirect_to students_path
            else
                render 'admins/show'
            end
        else
            @course = Course.find(params[:course_id])
            @teacher = @course.teacher_id
            
            if exist_email(@student.email)
                @existStudent = Student.where(email: @student.email).first
                if !email_in_course(@course, @student.email)
                    @existStudent.courses << @course
                end
                redirect_to teacher_course_path(@teacher, @course)
            else
                if @student.save
                    @student.courses << @course
                    redirect_to course_path(@course)
                else
                    render 'new'
                end
            end
        end
    end
    
    def update
        @student = Student.find(params[:id])
        #temporary Course
        @course = Course.new
        @course.id = 0

        if params[:course_id].present?
            @course = Course.find(params[:course_id])
            if @student.update(student_params)
                redirect_to course_student_path(@course, @student)
            else
                render 'edit'
            end
        else
            if @student.update(student_params)
                redirect_to student_path(@student)
            else
                render 'edit'
            end
        end
    end

    def destroy
        #if deleting student from course
        if params[:course_id].present?
            @course = Course.find(params[:course_id])
            @course.students.delete(Student.find(params[:id]))

            redirect_to course_path(@course)
        #if deleting student from database
        else
            @student = Student.find(params[:id])
            @courses = @student.courses

            for course in @courses do
                @card = course.cards.where(email: @student.email).first
                course.students.delete(Student.find(params[:id]))
            end
            if !@card.nil?
                @card.destroy
            end
    
            @student.destroy
            redirect_to students_path
        end
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
        
        def email_in_course(course, email)
            ret = false
            for student in course.students do
                if student.email == email
                    ret = true
                end
            end
            ret
        end
        
        def student_params
            params.require(:student).permit(:fname, :mname, :lname, :prefname, :uin, :email, :card_num)
        end
end 