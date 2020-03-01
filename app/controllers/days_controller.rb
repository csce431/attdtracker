class DaysController < ApplicationController
  def index
    @course = Course.find(params[:course_id])
    @tookattendance = time_exist(@course)
    @time = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y")
    @days = @course.days
    @day = Day.where(classday: @time).first
    if(@course.days.first)
      @classday = @course.days.first.classday
    end
  end
  
  def show
    @day = Day.find(params[:id])
  end
  
  def new
    @day = Day.new
    @course = Course.find(params[:course_id])
  end
  
  def edit
    @day = Day.find(params[:id])
  end
  
  def create
    @day = Day.new
    @course = Course.find(params[:course_id])
    
    @day.classday = Time.now.in_time_zone('Central Time (US & Canada)').strftime("%m-%d-%Y")
    
    if @day.save!
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
    
    redirect_to day_index_path
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
  
  private
    def day_params
      params.require(:day).permit(:classday)
    end
end
