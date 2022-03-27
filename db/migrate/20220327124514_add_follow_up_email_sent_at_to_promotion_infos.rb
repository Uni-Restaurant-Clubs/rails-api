class AddFollowUpEmailSentAtToPromotionInfos < ActiveRecord::Migration[6.1]
  def change
    add_column :promotion_infos, :follow_up_email_sent_at, :datetime
    add_column :promotion_infos, :review_is_up_email_sent_at, :datetime
  end
end
