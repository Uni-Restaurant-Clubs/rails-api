class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :description
      t.integer :address_id
      t.text :manager_info
      t.string :primary_phone_number
      t.string :primary_email
      t.text :other_contact_info
      t.text :managers
      t.integer :status
      t.text :notes
      t.string :website_url
      t.string :google_url

      t.timestamps
    end
    add_index :restaurants, :address_id
    add_index :restaurants, :status
  end
end
