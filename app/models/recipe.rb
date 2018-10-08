# frozen_string_literal: true

# Recipe model
class Recipe < ApplicationRecord
  belongs_to :chef
  validates :chef_id, presence: true
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  mount_uploader :image, ImageUploader

  def thumbs_up_total
    self.likes.where(like: true).size
  end

  def thumbs_down_total
    self.likes.where(like: false).size
  end
end
