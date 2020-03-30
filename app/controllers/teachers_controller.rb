class TeachersController < ApplicationController
    def index
        #admin
        @teachers = Teacher.all
    end
    
    def new
        @teacher = Teacher.new
    end

    def create
    end
    
    def show
        #teacher/:id/courses
        @teacher = Teacher.find(params[:id])
    end 
    
    def edit
    end
    
    def update
    end
end
