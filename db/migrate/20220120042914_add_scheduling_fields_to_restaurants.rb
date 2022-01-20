class AddSchedulingFieldsToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :scheduling_form_url, :string
    add_column :restaurants, :scheduling_token, :string
    add_column :restaurants, :scheduling_token_created_at, :datetime
    add_column :restaurants, :submitted_scheduling_form_at, :datetime
    add_index :restaurants, :scheduling_token, unique: true
  end
end
