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

University.find_or_create_by(name: "Texas A&M", school_type: "university")

photographer_data = {
  first_name: "Mr",
  last_name: "photographer",
  email: "test@photography.com",
  phone: "555 555 5555",
  drive_folder_url: "https://drive.com/folder_name",
  university_id: 2
}
Photographer.find_or_create_by(photographer_data)

writer_data = {
  first_name: "Mr",
  last_name: "writer",
  email: "test@writer.com",
  phone: "555 555 5555",
  drive_folder_url: "https://drive.com/folder_name",
  university_id: 2
}
Writer.find_or_create_by(writer_data)
