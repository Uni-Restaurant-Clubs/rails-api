class AddSocialMediaInfoToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :instagram_username, :string
    add_column :restaurants, :cellphone_number, :string
    add_column :restaurants, :restaurant_replied_through, :integer
    add_column :restaurants, :date_we_contacted_them, :datetime
    add_column :restaurants, :date_restaurant_replied, :datetime
    add_index :restaurants, :restaurant_replied_through
    add_column :restaurants, :facebook_username, :string
    add_column :restaurants, :did_we_phone_them, :boolean, default: false
    add_index :restaurants, :did_we_phone_them
    add_column :restaurants, :did_we_instagram_message_them, :boolean, default: false
    add_index :restaurants, :did_we_instagram_message_them
    add_column :restaurants, :did_we_facebook_message_them, :boolean
    add_index :restaurants, :did_we_facebook_message_them
    add_column :restaurants, :did_we_email_them, :boolean, default: false
    add_index :restaurants, :did_we_email_them
    add_column :restaurants, :did_we_contact_them_through_website, :boolean, default: false
    add_index :restaurants, :did_we_contact_them_through_website
  end
end
