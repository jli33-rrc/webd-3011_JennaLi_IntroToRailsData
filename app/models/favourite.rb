class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :breed

  # Validations
  validates :user_id, presence: true
  validates :breed_id, presence: true
  validates :breed_id, uniqueness: { scope: :user_id, message: "is already favourited by this user" }
end
