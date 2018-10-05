class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show destroy edit update destroy like]
  before_action :require_chef, only: %i[new create edit update destroy]
  before_action :require_same_chef, only: %i[edit update destroy]
  before_action :require_chef_like, only: [:like]

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
    @recipe.destroy
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

  def like
    like = Like.create(like: params[:like], chef: current_chef, recipe: @recipe)
    if like.valid?
      flash[:success] = "Your selection was succesful"
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "You can only like/dislike a recipe once"
      redirect_back(fallback_location: root_path)
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

  def require_chef_like
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_back(fallback_location: root_path)
    end
  end
end
