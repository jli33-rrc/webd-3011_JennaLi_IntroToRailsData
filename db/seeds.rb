# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "httparty"
require "faker"

puts "Clearing old data..."

Favourite.destroy_all
User.destroy_all
Breed.destroy_all

# ===============================================================================
# Data Source #1: Dog CEO API
# ===============================================================================

puts "Fetching dog breeds from Dog CEO API..."

response = HTTParty.get('https://dog.ceo/api/breeds/list/all')
breed_data = response.parsed_response['message']

breed_count = 0

breed_data.each do |breed, subbreeds|
  if subbreeds.any?
    subbreeds.each do |sub|
      Breed.create!(name: "#{sub} #{breed}")
      breed_count += 1
    end
  else
    Breed.create!(name: breed)
    breed_count += 1
  end
end

puts "Created #{breed_count} breeds."

# ===============================================================================
# Data Source #2: API endpoint for images
# ===============================================================================

puts "Fetching images for breeds..."

Breed.all.each do |breed|
  formatted_name = breed.name.gsub(' ', '/')
  image_response = HTTParty.get("https://dog.ceo/api/breed/#{formatted_name}/images/random")
  if image_response.code == 200 && image_response.parsed_response["message"].present?
    breed.update(image_url: image_response.parsed_response["message"])
  end
end

puts "Added images for breeds."

# ===============================================================================
# Data Source #3: Faker
# ===============================================================================

puts "Creating users..."

100.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email
  )
end

puts "Created #{User.count} users."

# ===============================================================================
# Favourites (Join data between users & breeds)
# ===============================================================================

puts "Creating favourites..."

User.all.each do |user|
  # Each user favourites between 2–5 random breeds
  user.breeds << Breed.order("RANDOM()").limit(rand(2..5))
end

puts "Created #{Favourite.count} favourites."

# ===============================================================================
# Summary
# ===============================================================================

total_rows = User.count + Breed.count + Favourite.count
puts "Seeding complete! Total records: #{total_rows}"
