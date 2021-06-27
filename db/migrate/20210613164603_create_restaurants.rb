class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.string :yelp_id
      t.string :yelp_alias
      t.string :image_url
      t.string :yelp_url
      t.string :primary_phone_number
      t.string :primary_email
      t.text :manager_info
      t.integer :operational_status
      t.text :other_contact_info
      t.integer :status, default: 0
      t.text :notes
      t.datetime :scheduled_review_date_and_time
      t.string :website_url

      t.timestamps
    end
    add_index :restaurants, :status
    add_index :restaurants, :yelp_id, unique: true
    add_index :restaurants, :operational_status
  end
end
