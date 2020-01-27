class HomeController < ApplicationController
def index
  @homes = Home.all
end

def show
  #note to self, when call redirect_to @object, it automatically goes to show
  @home = Home.find(params[:id])
end

def new
  @home = Home.new
end

def edit
  @home = Home.find(params[:id])
end

def create
  @home = Home.new(home_params)

  if @home.save
    redirect_to @home
  else
    render 'new'
  end
  #render plain: params[:home].inspect
end

def update
  @home = Home.find(params[:id])
  
  if @home.update(home_params)
    redirect_to controller: 'home'
  else
    render 'edit'
  end
end

def destroy
  @home = Home.find(params[:id])
  @home.destroy
  
  redirect_to home_index_path
end

private
  def home_params
    params.require(:home).permit(:card)
  end

end
