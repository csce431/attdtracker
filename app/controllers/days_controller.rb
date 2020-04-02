class DaysController < ApplicationController

  helper_method :sort_column, :sort_direction

  def index
    @course = Course.find(params[:course_id])

    @courses = Course.all

    @tookattendance = time_exist(@course)
    @time = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y")
    @days = @course.days
    @day = @days.where(classday: @time).first
    @all_days = Day.all
    @cards = @course.cards

   # if !params[:days]
      @students = @course.students.order(sort_column + " " + sort_direction)
    #else
     # @students = @course.students.order(sort_column_day + " " + sort_direction)
    #end 

    if(@course.days.first)
      @classday = @course.days.first.classday
    end
  end
  
  def show
    @day = Day.find(params[:id])
    @course = Course.find(params[:course_id])
  end
  
  def new
    #@day = Day.new
    @time = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y")
    @course = Course.find(params[:course_id])
    @days = @course.days
    @cards = @course.cards
    @db = Day.all
  
    if !@db.include? @days.ids
      @day = Day.new 
    else
      @day = @days.id
    end  
  end
  
  def edit
    @day = Day.find(params[:id])
  end
  
  def create
    @day = Day.new
    @course = Course.find(params[:course_id])
    
    @day.classday = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y")
    
    if day_exist_in_course(@day.classday, @course)
      @day = Day.where(classday: @day.classday).first
      redirect_to new_course_day_card_path(@course, @day)
    elsif @day.save!
      @day.classday = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y")
      @course.days << @day
      redirect_to new_course_day_card_path(@course, @day)
    else
      redirect_to courses_path
    end
  end
  
  def update
    @day = Day.find(params[:id])
    @day.update(day_params)
    if @day.update(day_params)
      redirect_to controller: 'day'
    else
      render 'edit'
    end
  end
  
  def destroy
    @day = Day.find(params[:id])
    @day.destroy
    
    redirect_to course_days_path
  end
  
  def time_exist(course)
    #return value 'ret'
    ret = false
    time = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y") 
    for day in course.days do
      if day.classday == time
        ret = true
      end 
    end 
    ret
  end
  
  def day_exist_in_course(classday, course)
      ret = false
      for day in course.days do
          if day.classday == classday
              ret = true
          end
      end
      ret            
  end
  
  private
    def day_params
      params.require(:day).permit(:classday)
    end

    def sort_column
        Student.column_names.include?(params[:sort]) ? params[:sort] : "lname"
    end     
      
    def sort_column_day
      
    end   

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end 
      
end
