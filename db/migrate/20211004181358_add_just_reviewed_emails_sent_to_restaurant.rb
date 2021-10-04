class AddJustReviewedEmailsSentToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :just_reviewed_emails_sent, :boolean, default: false
    add_index :restaurants, :just_reviewed_emails_sent
  end
end
