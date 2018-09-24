require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Joao", email: "joao@example.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Joao2", email: "joao2@example.com", password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "admin", email: "admin@example.com", password: "password", password_confirmation: "password", admin: true)
  end

  test "reject invalid chef edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: " " } }
    assert_template 'shared/_page_title'
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end

  test "accept valid chef edit" do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "chef1", email: "chef1@example.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "chef1", @chef.chefname
    assert_match "chef1@example.com", @chef.email
  end

  test "accept edit from admin" do
    sign_in_as(@admin_user, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "chef1", email: "chef1@example.com" }}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "chef1", @chef.chefname
    assert_match "chef1@example.com", @chef.email
  end

  test "accept edit by a non-admin to a chefs profile" do
    sign_in_as(@chef2, "password")
    updated_name = "chef1"
    updated_email = "chef1@example.com"
    patch chef_path(@chef), params: { chef: { chefname: updated_name, email: updated_email }}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Joao", @chef.chefname
    assert_match "joao@example.com", @chef.email
  end
end
