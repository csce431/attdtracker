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
        
    end
    
    def show
        @student = Student.find(params[:id])
        @courses = @student.courses.all
    end
    
    def create
        @student = Student.new(student_params)
        if !params[:course_id]
            @student.save!
            redirect_to students_path
        else
            @course = Course.find(params[:course_id])
            @teacher = @course.teacher_id
            
            if exist_email(@student.email)
            begin
                @existStudent = Student.where(email: @student.email).first
                if !email_in_course(@course, @student.email)
                    @existStudent.courses << @course
                end
                redirect_to teacher_course_path(@teacher, @course)
            end
            else
                if @student.save
                begin
                    @student.courses << @course
                    redirect_to course_path(@course)
                end
                else
                    render 'new'
                end
            end
        end
    end
    
    def update
        @student = Student.find(params[:id])
 
        if @student.update(student_params)
            redirect_to @student
        else
            render 'edit'
        end
    end

    def destroy
        @student = Student.find(params[:id])
        if !params[:course_id]
            @student.destroy
            redirect_to students_path
        else
            @course = Course.find(params[:course_id])
            @course.students.delete(Student.find(params[:id]))
            
            redirect_to course_path(@course)
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