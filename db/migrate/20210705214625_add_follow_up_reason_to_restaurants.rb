class AddFollowUpReasonToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :follow_up_reason, :integer
    add_index :restaurants, :follow_up_reason
  end
end
