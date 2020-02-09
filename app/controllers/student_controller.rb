class StudentController < ApplicationController

  def index
    render('home/student')
  end

  def show
    #note to self, when call redirect_to @object, it automatically goes to show
    @student = Home.find(params[:id])
  end
  
  def edit
    @student = Home.find(params[:id])
  end 
  
  def update
    @student = Home.find(params[:id])
    @student.update(params.require(:home).permit(:card, :name))
    if @student.update(home_params)
      redirect_to controller: 'student'
    else
      render 'edit'
    end
  end
  
end