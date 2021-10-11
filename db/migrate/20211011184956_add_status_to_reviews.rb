class AddStatusToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :status, :integer, default: 0
    add_index :reviews, :status
  end
end
