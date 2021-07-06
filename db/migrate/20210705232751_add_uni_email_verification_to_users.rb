class AddUniEmailVerificationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :confirm_uni_email_token, :string
    add_column :users, :uni_email_confirmed_at, :datetime
    add_column :users, :uni_email, :string
    add_column :users, :pending_uni_email, :string
    add_column :users, :confirm_uni_email_sent_at, :datetime
    add_index :users, :confirm_uni_email_token
  end
end
