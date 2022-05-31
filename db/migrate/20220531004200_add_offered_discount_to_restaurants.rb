class AddOfferedDiscountToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :offered_discount, :string
  end
end
