class AddSchedulingInfoToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :scheduling_phone_number, :string
    add_column :restaurants, :scheduling_notes, :text
  end
end
