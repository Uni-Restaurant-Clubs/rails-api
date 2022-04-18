class AddPromotionFieldsToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :promotion_form_token, :string
    add_index :restaurants, :promotion_form_token
    add_column :restaurants, :promotion_form_step_one_completed_at, :datetime
    add_column :restaurants, :selected_not_interested_in_promotion, :boolean
  end
end
