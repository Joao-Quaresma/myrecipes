# frozen_string_literal: true

# Recipe model
class Recipe < ApplicationRecord
  validates :name, presence: true
end
