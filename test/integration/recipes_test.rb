require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup

    @chef = Chef.create!(chefname: "joao", email: "joao@example.com")
    @recipe = Recipe.create(name: "Vegetables", description: "Great vegetables cooked", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken", description: "amazing chickens")
    @recipe2.save
  end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe.name, response.body
  end
end
