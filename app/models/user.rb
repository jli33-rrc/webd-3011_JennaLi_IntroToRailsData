class User < ApplicationRecord
  has_many :favourites
  has_many :breeds, through: :favourites

  # Validations
  validates :name, presence: true, length: { minimum: 2 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 20 }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }
end
