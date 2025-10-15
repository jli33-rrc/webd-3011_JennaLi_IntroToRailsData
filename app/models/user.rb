class User < ApplicationRecord
  has_many :favourites
  has_many :breeds, through: :favourites

  # Validations
  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
