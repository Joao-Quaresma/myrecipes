class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show destroy edit update destroy]
  before_action :require_chef, only: %i[new create edit update destroy]
  before_action :require_same_chef, only: %i[edit update destroy]

  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 10).order("updated_at DESC")
  end

  def show
    @comments = @recipe.comments.paginate(page: params[:page], per_page: 5)
    @comment = Comment.new
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_chef
    if @recipe.save
      flash[:success] = "Recipe was created successfully!"
      redirect_to recipe_path(@recipe)
    else
      render 'new'
    end
  end

  def edit;end

  def destroy
    @recipe.delete
    flash[:danger] = "Recipe successfully deleted!"
    redirect_to recipes_path
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Recipe was updated successfully!"
      redirect_to recipe_path(@recipe)
    else
      render 'edit'
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, ingredient_ids: [])
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def require_same_chef
    if @recipe.chef != current_chef && !current_chef.admin?
      flash[:danger] = "You can only edit or delete your own recipes!"
      redirect_to recipes_path
    end
  end
end
