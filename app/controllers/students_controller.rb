class StudentsController < ApplicationController
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
        @email = @student.email
        if(@courses.first.cards.where(email: @student.email).first)
            @card = @courses.first.cards.where(email: @student.email).first.code
        else
            @card = "N/A"
        end
    end
    
    def create
        @student = Student.new(student_params)
        @course = Course.find(params[:course_id])
        
        if exist_email(@student.email)
        begin
            @existStudent = Student.where(email: @student.email).first
            if !email_in_course(@course, @student.email) 
                @existStudent.courses << @course
            end
            redirect_to course_path(@existStudent.courses.last)
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
        @student.destroy
 
        redirect_to courses_path(@course)
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
            params.require(:student).permit(:fname, :mname, :lname, :prefname, :uin, :email)
        end
end 