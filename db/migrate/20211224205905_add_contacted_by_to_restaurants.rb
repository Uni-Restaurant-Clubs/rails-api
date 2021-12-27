class AddContactedByToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :contacted_by, :integer
    add_column :restaurants, :preferred_contact_method, :integer
    add_index :restaurants, :contacted_by
    add_index :restaurants, :preferred_contact_method
  end
end
