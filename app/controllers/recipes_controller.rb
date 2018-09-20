class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show destroy edit update]
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page:10).order("updated_at DESC")
  end


  def show
    @chef = Chef.first
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = Chef.first
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
    params.require(:recipe).permit(:name, :description)
  end

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end
end
