class HomeController < ApplicationController
def show
    @home = Home.find(params[:id])
end

def new
end

def create
  #@home = Home.new(home_params)
  #@home.save
  #redirect_to @home
  render plain: params[:home].inspect
  
  #render a new page for more inputs
end

private
  def home_params
    params.require(:home).permit(:card)
  end



end
