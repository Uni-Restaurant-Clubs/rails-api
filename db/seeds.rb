# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'uri'

return if Rails.env.production?

if !AdminUser.find_by(email: "test@admin.com")
  AdminUser.create!(email: 'test@admin.com', password: 'q1w2e3r4',
                  password_confirmation: 'q1w2e3r4')
end

location_code = LocationCode.find_or_create_by!(code: "BR", state: "NY",
                                                description: "brooklyn")

nda = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/fake_agreement.pdf')
agreement = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/fake_agreement.pdf')
writer_pic = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/manar.jpeg')
photographer_pic = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/kirsys.png')
photographer_data = {
  first_name: "Kirsys",
  last_name: "Cresencio",
  public_unique_username: "kirsys_cresencio",
  creator_type: "photographer",
  location_code_id: location_code.id,
  email: "test@photography.com",
  phone: "555 555 5555",
  drive_folder_url: "https://drive.com/folder_name",
}

photographer = ContentCreator.find_or_initialize_by(photographer_data)
photographer.signed_nda.attach(io: nda, filename: "nda.pdf")
photographer.signed_agreement.attach(io: agreement, filename: "agreement.pdf")
photographer.save!

image = Image.find_or_initialize_by(content_creator_id: photographer.id)
image.photo.attach(io: photographer_pic, filename: "photographer.png")
image.save!

writer_data = {
  first_name: "Manar",
  last_name: "Elkhayyal",
  public_unique_username: "manar_elkhayyal",
  creator_type: "writer",
  location_code_id: location_code.id,
  email: "test@writer.com",
  phone: "555 555 5555",
  drive_folder_url: "https://drive.com/folder_name",
}

nda = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/fake_agreement.pdf')
agreement = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/fake_agreement.pdf')

writer = ContentCreator.find_or_initialize_by(writer_data)
writer.signed_nda.attach(io: nda, filename: "nda.pdf")
writer.signed_agreement.attach(io: agreement, filename: "agreement.pdf")
writer.save!

image = Image.find_or_initialize_by(content_creator_id: writer.id)
image.photo.attach(io: writer_pic, filename: "writer.jpeg")
image.save!

=begin
restaurant_data = {
  name: "Best restaurant ever",
  description: "this is the best restaurant ever",
  primary_phone_number: "555 555 5555",
  primary_email: "manager@gmail.com",
  manager_info: "Mr manager",
  operational_status: "unknown",
  other_contact_info: "",
  status: "not contacted",
  notes: "the best",
  website_url: "google.com",
  is_franchise: false,
  starred: true,
  urc_rating: "ok nothing special",
  yelp_rating: nil,
  yelp_review_count: 0,
  follow_up_reason: "need to contact marketing team"
}

restaurant = Restaurant.find_or_create_by!(restaurant_data)

review_data = {
  reviewed_at: Time.new,
  writer_id: writer.id,
  photographer_id: photographer.id,
  university_id: uni.id,
  restaurant_id: restaurant.id
}

Review.find_or_create_by!(review_data)
=end
