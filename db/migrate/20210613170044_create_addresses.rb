class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :geocoded_address
      t.string :instructions
      t.string :apt_suite_number
      t.string :street_number
      t.string :street_name
      t.string :address_1
      t.string :address_2
      t.string :address_3
      t.integer :street_type
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.float :latitude
      t.float :longitude
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :addresses, :city
    add_index :addresses, :country
    add_index :addresses, :restaurant_id
  end
end
