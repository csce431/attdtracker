class StudentController < ApplicationController

  def index
    render('home/student')
  end

  def show
    #note to self, when call redirect_to @object, it automatically goes to show
    @student = Home.find(params[:id])
  end

end
