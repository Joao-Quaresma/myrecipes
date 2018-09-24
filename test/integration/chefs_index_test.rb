require 'test_helper'

class ChefsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @chef1 = Chef.create!(chefname: "Joao1", email: "joao1@example.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Joao2", email: "joao2@example.com", password: "password", password_confirmation: "password")
  end

  test "should get chefs list" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef1), text: @chef1.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.chefname.capitalize
    @chef1.recipes.count > 0 ? "#{@chef1.recipes.count} recipe" : "#{@chef1.recipes.count} recipes"
    @chef2.recipes.count > 0 ? "#{@chef2.recipes.count} recipe" : "#{@chef2.recipes.count} recipes"
  end

  test "should delete chef" do
    sign_in_as(@chef1, "password")
    sign_in_as(@chef2, "password")
    get chefs_path
    assert_template 'chefs/index'
    assert_difference 'Chef.count', -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
