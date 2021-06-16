class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :google_icon
      t.text :description
      t.text :manager_info
      t.string :google_place_id
      t.string :google_business_status
      t.string :google_rating_avg
      t.string :google_ratings_total
      t.text :google_all_details_json
      t.string :primary_phone_number
      t.string :primary_email
      t.text :other_contact_info
      t.text :managers
      t.integer :status, default: 0
      t.text :notes
      t.datetime :scheduled_review_date_and_time
      t.string :website_url
      t.string :google_map_url

      t.timestamps
    end
    add_index :restaurants, :status
    add_index :restaurants, :google_place_id, unique: true
  end
end
