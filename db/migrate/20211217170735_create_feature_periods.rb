class CreateFeaturePeriods < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_periods do |t|
      t.integer :discount_type
      t.integer :discount_number
      t.integer :status
      t.datetime :start_date
      t.datetime :end_date
      t.text :disclaimers
      t.text :perks
      t.text :notes
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :feature_periods, :discount_type
    add_index :feature_periods, :status
    add_index :feature_periods, :restaurant_id
  end
end
