class CreateCheckIns < ActiveRecord::Migration[6.1]
  def change
    create_table :check_ins do |t|
      t.string :lat
      t.string :lng
      t.integer :restaurant_id
      t.integer :feature_period
      t.integer :user_id

      t.timestamps
    end
    add_index :check_ins, :restaurant_id
    add_index :check_ins, :feature_period
    add_index :check_ins, :user_id
  end
end
