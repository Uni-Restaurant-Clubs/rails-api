class AddEmailCodeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :passwordless_email_code, :string
    add_column :users, :passwordless_email_code_sent_at, :datetime
    add_index :users, :passwordless_email_code, unique: true
  end
end
