class AddPromotionFieldsToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :promotion_form_token, :string
    add_index :restaurants, :promotion_form_token
    add_column :restaurants, :selected_not_interested_in_promotion_at, :datetime
  end
end
