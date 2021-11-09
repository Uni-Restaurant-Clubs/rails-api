class AddGoogleEventInfoToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :restaurant_event_id, :string
    add_column :restaurants, :restaurant_event_url, :string
    add_column :restaurants, :creators_event_id, :string
    add_column :restaurants, :creators_event_url, :string
  end
end
