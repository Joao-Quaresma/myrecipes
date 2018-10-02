class Comment < ApplicationRecord
  validates :description, presence: true, length: { minimun: 4, maximum: 140 }
  belongs_to :chef
  validates :chef_id, presence: true
  validates :recipe_id, presence: true
  default_scope -> { order(updated_at: :desc) }
  belongs_to :recipe
end