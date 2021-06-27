class AddIsFranchiseToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :is_franchise, :boolean, default: false
    add_index :restaurants, :is_franchise
  end
end
