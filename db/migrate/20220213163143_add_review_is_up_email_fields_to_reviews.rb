class AddReviewIsUpEmailFieldsToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :review_is_up_email_sent_at, :datetime
    add_column :reviews, :review_is_up_email_sent_by_admin_user_id, :integer
    add_index :reviews, :review_is_up_email_sent_by_admin_user_id
  end
end
