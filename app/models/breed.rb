class Breed < ApplicationRecord
  has_many :favourites
  has_many :users, through: :favourites

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :image_url, format: { with: /\Ahttps?:\/\/.+\.(jpg|jpeg|png|gif)\z/i, message: "must be a valid image URL" }, allow_blank: true
end
