class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :geocoded_address
      t.string :instructions
      t.string :apt_suite_number
      t.string :street_number
      t.string :street_name
      t.integer :street_type
      t.integer :city
      t.integer :state
      t.integer :country
      t.string :zipcode
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
    add_index :addresses, :street_type
    add_index :addresses, :city
    add_index :addresses, :country
  end
end
