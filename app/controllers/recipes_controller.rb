class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all.order("created_at DESC")
  end

  def create

  end

  def new

  end

  def update

  end

  def edit

  end

  def destroy

  end
end
