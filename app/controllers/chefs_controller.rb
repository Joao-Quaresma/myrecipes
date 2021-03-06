class ChefsController < ApplicationController
  before_action :find_chef, only: %i[show edit update destroy]
  before_action :require_same_chef, only: %i[edit update destroy]
  before_action :require_admin, only: [:destroy]
  def new
    @chef = Chef.new
  end

  def create
    @chef = Chef.new(chef_params)
    if @chef.save
      session[:chef_id] = @chef.id
      cookies.signed[:chef_id] = @chef.id
      flash[:success] = "Welcome #{@chef.chefname} to MyRecipes App!"
      redirect_to chef_path(@chef)
    else
      render 'new'
    end
  end

  def show
    @chef_recipes = @chef.recipes.paginate(page: params[:page], per_page: 5).order("updated_at ASC")
  end

  def edit; end

  def update
    if @chef.update(chef_params)
      flash[:success] = "Profile updated!"
      redirect_to @chef
    else
      render 'edit'
    end
  end

  def index
    @chefs = Chef.paginate(page: params[:page], per_page:10).order("chefname ASC")
  end

  def destroy
    @chef.destroy
    flash[:danger] = "Chef and all associated recipes have been deleted!"
    redirect_to chefs_path
  end

  private

  def chef_params
    params.require(:chef).permit(:chefname, :email, :password, :password_confirmation)
  end

  def find_chef
    @chef = Chef.find(params[:id])
  end

  def require_same_chef
    if @chef != current_chef && !current_chef.admin?
      flash[:danger] = "You can only edit or delete your own profile!"
      redirect_to chefs_path
    end
  end

  def require_admin
    if current_chef != @chef && !current_chef.admin?
      flash[:danger] = "Only Admin users can perform that action!"
      redirect_to chefs_path
    elsif current_chef == @chef
      session[:chef_id] = nil
      @chef.destroy
      flash[:success] = "Chef Deleted"
      redirect_to chefs_path
    elsif current_chef != @chef && current_chef.admin?
      @chef.destroy
      flash[:success] = "Chef Deleted"
      redirect_to chefs_path
    end
  end
end
