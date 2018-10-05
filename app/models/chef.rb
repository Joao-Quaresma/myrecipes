# frozen_string_literal: true

# Chef model
class Chef < ApplicationRecord
  has_many :recipes, dependent: :destroy
  before_save { self.email = email.downcase }
  validates :chefname, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  #when signing up has_secure_password will enforce a password
  has_secure_password
  #when editing  allow_nil: true will allow us to not update the password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy
end
