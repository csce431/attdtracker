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
    end
    
    def create
        @student = Student.new(student_params)
        
        if @student.save
        begin
            if @course 
            begin
                @course = Course.find(params[:course_id])
                @student.courses << @course
                @course.students << @student
                redirect_to course_path(@course)
            end
            else
                redirect_to courses_path
            end
        end
        else
            render 'new'
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
        def student_params
            params.require(:student).permit(:fname, :mname, :lname, :prefname, :uin, :email)
        end
end 