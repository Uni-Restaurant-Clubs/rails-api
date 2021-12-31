class CreateNewCheckIns < ActiveRecord::Migration[6.1]
  def change
    create_table :check_ins do |t|
      t.string :latitude
      t.string :longitude
      t.integer :restaurant_id
      t.integer :feature_period_id
      t.boolean :user_is_at_restaurant, default: false
      t.integer :user_id

      t.timestamps
    end
    add_index :check_ins, :restaurant_id
    add_index :check_ins, :user_is_at_restaurant
    add_index :check_ins, :feature_period_id
    add_index :check_ins, :user_id
  end
end
