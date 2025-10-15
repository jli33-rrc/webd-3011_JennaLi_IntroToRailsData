class User < ApplicationRecord
  has_many :favourites
  has_many :breeds, through: :favourites
end
