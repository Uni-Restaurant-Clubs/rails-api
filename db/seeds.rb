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
puts "created location code"

time = Time.now
nda = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/fake_agreement.pdf')
agreement = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/fake_agreement.pdf')
writer_pic = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/manar.jpeg')
photographer_pic = URI.open('https://urc-public-images.s3.us-east-2.amazonaws.com/kirsys.png')
photographer_data = {
  first_name: "Kirsys",
  last_name: "Cresencio",
  facebook_url: "https://facebook.com",
  instagram_url: "https://instagram.com",
  linkedin_url: "https://linkedin.com",
  youtube_url: "https://youtube.com",
  website_url: "https://website.com",
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

puts "created photographer"

writer_data = {
  first_name: "Manar",
  last_name: "Elkhayyal",
  facebook_url: "https://facebook.com",
  instagram_url: "https://instagram.com",
  linkedin_url: "https://linkedin.com",
  youtube_url: "https://youtube.com",
  website_url: "https://website.com",
  bio: "<p class=\"ql-align-justify\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ultrices est lorem, vel sollicitudin odio condimentum eu. Morbi vel accumsan urna. In vitae elit id ligula efficitur imperdiet eu ut orci. Sed elementum, turpis ac volutpat pulvinar, mauris nisl eleifend justo, tincidunt cursus justo elit id tortor.</p><p class=\"ql-align-justify\">Donec gravida erat at odio consectetur, eget aliquet ligula tincidunt. Nunc augue nibh, suscipit ut feugiat at, fringilla quis ante. Quisque enim turpis, tristique a faucibus quis, tempor sed tellus. <span style=\"background-color: rgb(255, 255, 255);\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. In ultrices est lorem, vel sollicitudin odio condimentum eu. Morbi vel accumsan urna. In vitae elit id ligula efficitur imperdiet eu ut orci. Sed elementum, turpis ac volutpat pulvinar, mauris nisl eleifend justo, tincidunt cursus justo elit id tortor.</span></p>",
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

puts "created writer"
restaurant_data = {
  name: "Cacao 70",
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
  reviewed_at: time,
  writer_id: writer.id,
  article_title: "great spot in heart of downtown",
  full_article: "<p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">With its motto “Eat Healthy! Eat Differently!” Zyng is definitely one of the best Asian fusion restaurants in Montreal. Combining Chinese, Japanese, Vietnamese and Thai food, and very reasonable prices, this is a great place to treat yourself to a delicious, healthy meal. All the classic Asians dishes are served here, from spring rolls to miso soup. There is a large variety of dishes served with either rice or noodles. The restaurant’s signature dish, however, is the Tepanyaki ($12.75 with protein/$9.99 vegetarian). This dish is great, because it’s essentially teamwork between you and the chefs at Zyng. First, you choose between six types of noodles, rice or lettuce. Next you pick your protein, should you wish to have some, from the four choices of chicken, beef, shrimp or tofu, and then the flavoring for your dish. But that’s not all! You are also provided with a small bowl, which you are invited to take to the vegetable bar. There is a wide selection to choose from, and whatever you can fit in the bowl, goes into your dish! Once your bowl is full, leave it by the Panda on the counter and the chef will promptly prepare it to add to your dish.</span></p><p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">Another top choice on the Zyng menu is the “Meal in a Bowl” at $19.50. This is exactly what it sounds like: a typical Asian dish, served in a bowl. The choices include Sweet and Sour Chicken, General Tao, or Crispy-Honey Soy Chicken.&nbsp; There are also noodle soup meals, which cost on average around $10. I would also recommend trying Zyng’s Mango Ice Tea. Made with mango, lychee, passion fruit and black tea, this refreshing drink is a must have! You can also opt for the Zangria - Zyng’s own fruity and colorful interpretation of a classic Sangria.&nbsp;</span></p><p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">But Zyng also has other advantages. Students get 10% off every meal, there’s free Wi-Fi provided and free coffee between 2 and 5 P.M. everyday! This restaurant is therefore a good place to go out for a meal with friends as well as a place to study while enjoying a delicious meal of noodles or rice. The staff is also very friendly, so any questions you may have will be readily answered - don’t hesitate to ask! And with its impressively large menu, Zyng is sure to please everyone.&nbsp;</span></p><p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">With its locations in Montreal (St. Denis, Mont-Royal and the West Island), Zyng is definitely the place to go if you are looking for healthy, tasty and fun fusion food. So don’t hesitate to drop by!</span></p>",
  photographer_id: photographer.id,
  restaurant_id: restaurant.id
}

puts "created restaurant"
review = Review.find_or_create_by!(review_data)

puts "created review"

number = 1
featured = false

8.times do |i|
  featured = number == 6 ? true : false
  pic = URI.open("https://urc-public-images.s3.us-east-2.amazonaws.com/Cocoa70-#{number}.jpg")
  image = Image.find_or_initialize_by(featured: featured, review_id: review.id,
                                      title: "sample photo #{number}.jpg" )
  image.photo.attach(io: pic, filename: "sample_food_pic.jpg")
  image.save!
  puts "created image #{number}"
  number += 1
end

restaurant_data = {
  name: "Nil Bleu",
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
  reviewed_at: time,
  writer_id: writer.id,
  article_title: "great spot in heart of downtown",
  full_article: "<p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">With its motto “Eat Healthy! Eat Differently!” Zyng is definitely one of the best Asian fusion restaurants in Montreal. Combining Chinese, Japanese, Vietnamese and Thai food, and very reasonable prices, this is a great place to treat yourself to a delicious, healthy meal. All the classic Asians dishes are served here, from spring rolls to miso soup. There is a large variety of dishes served with either rice or noodles. The restaurant’s signature dish, however, is the Tepanyaki ($12.75 with protein/$9.99 vegetarian). This dish is great, because it’s essentially teamwork between you and the chefs at Zyng. First, you choose between six types of noodles, rice or lettuce. Next you pick your protein, should you wish to have some, from the four choices of chicken, beef, shrimp or tofu, and then the flavoring for your dish. But that’s not all! You are also provided with a small bowl, which you are invited to take to the vegetable bar. There is a wide selection to choose from, and whatever you can fit in the bowl, goes into your dish! Once your bowl is full, leave it by the Panda on the counter and the chef will promptly prepare it to add to your dish.</span></p><p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">Another top choice on the Zyng menu is the “Meal in a Bowl” at $19.50. This is exactly what it sounds like: a typical Asian dish, served in a bowl. The choices include Sweet and Sour Chicken, General Tao, or Crispy-Honey Soy Chicken.&nbsp; There are also noodle soup meals, which cost on average around $10. I would also recommend trying Zyng’s Mango Ice Tea. Made with mango, lychee, passion fruit and black tea, this refreshing drink is a must have! You can also opt for the Zangria - Zyng’s own fruity and colorful interpretation of a classic Sangria.&nbsp;</span></p><p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">But Zyng also has other advantages. Students get 10% off every meal, there’s free Wi-Fi provided and free coffee between 2 and 5 P.M. everyday! This restaurant is therefore a good place to go out for a meal with friends as well as a place to study while enjoying a delicious meal of noodles or rice. The staff is also very friendly, so any questions you may have will be readily answered - don’t hesitate to ask! And with its impressively large menu, Zyng is sure to please everyone.&nbsp;</span></p><p><span style=\"background-color: transparent; color: rgb(0, 0, 0);\">With its locations in Montreal (St. Denis, Mont-Royal and the West Island), Zyng is definitely the place to go if you are looking for healthy, tasty and fun fusion food. So don’t hesitate to drop by!</span></p>",
  photographer_id: photographer.id,
  restaurant_id: restaurant.id
}

puts "created restaurant"
review = Review.find_or_create_by!(review_data)

puts "created review"

number = 1
featured = false

number = 2
14.times do |i|
  featured = number == 15 ? true : false
  pic = URI.open("https://urc-public-images.s3.us-east-2.amazonaws.com/Nil+Bleu-1-#{number}.jpg")
  image = Image.find_or_initialize_by(featured: featured, review_id: review.id,
                                      title: "sample photo #{number}.jpg" )
  image.photo.attach(io: pic, filename: "sample_food_pic.jpg")
  image.save!
  puts "created image #{number}"
  number += 1
end
