# frozen_string_literal: true

# Recipe model
class Recipe < ApplicationRecord
  belongs_to :chef
  validates :chef_id, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
end
