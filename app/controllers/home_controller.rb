class HomeController < ApplicationController
def show
  #note to self, when call redirect_to @object, it automatically goes to show
    @home = Home.find(params[:id])
end

def new
end

def create
  @home = Home.new(home_params)
  @home.save
  redirect_to @home
  #render plain: params[:home].inspect
  
end

private
  def home_params
    params.require(:home).permit(:card)
  end



end
