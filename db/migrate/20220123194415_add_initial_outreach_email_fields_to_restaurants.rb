class AddInitialOutreachEmailFieldsToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :outreach_email_sent_at, :datetime
    add_column :restaurants, :outreach_email_intro_line, :string
    add_column :restaurants, :outreach_email_sent_by_admin_user_id, :integer
    add_index :restaurants, :outreach_email_sent_by_admin_user_id
  end
end
