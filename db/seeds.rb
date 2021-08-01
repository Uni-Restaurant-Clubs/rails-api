# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if !AdminUser.find_by(email: "test@admin.com")
  AdminUser.create!(email: 'test@admin.com', password: 'q1w2e3r4',
                  password_confirmation: 'q1w2e3r4') if Rails.env.development?
end

uni = University.find_or_create_by!(name: "Texas A&M", school_type: "university")

photographer_data = {
  first_name: "Mr",
  last_name: "photographer",
  email: "test@photography.com",
  phone: "555 555 5555",
  drive_folder_url: "https://drive.com/folder_name",
  university_id: uni.id
}
photographer = Photographer.find_or_create_by!(photographer_data)

writer_data = {
  first_name: "Mr",
  last_name: "writer",
  email: "test@writer.com",
  phone: "555 555 5555",
  drive_folder_url: "https://drive.com/folder_name",
  university_id: uni.id
}
writer = Writer.find_or_create_by!(writer_data)

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
