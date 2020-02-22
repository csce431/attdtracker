class HomeController < ApplicationController
  def index
    @roles = Role.all
    @course = Course.find(params[:course_id])
  end
  
  def show
    @role = Role.find(params[:id])
  end
  
  def new
    @role = Role.new
  end
  
  def edit
    @role = Role.find(params[:id])
  end
  
  def create
    @role = Role.new(Role_params)
    @role = Role.create(params.require(:role).permit(:card, :name, :lname))
  
    if @role.save
      redirect_to @role
    else
      render 'new'
    end
  end
  
  def update
    @role = Role.find(params[:id])
    @role.update(params.require(:role).permit(:card, :name, :lname))
    if @role.update(role_params)
      redirect_to controller: 'role'
    else
      render 'edit'
    end
  end
  
  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    
    redirect_to role_index_path
  end
  
  private
    def role_params
      params.require(:role).permit(:card)
    end
end