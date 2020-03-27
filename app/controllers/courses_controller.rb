class CoursesController < ApplicationController
    def index
        @courses = Course.order(:name)
    end

    def import
        
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
        @students = @course.students.order(:fname)
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
        def course_params
            params.require(:course).permit(:name, :number, :section)
        end
end
