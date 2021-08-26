class CreateContentCreators < ActiveRecord::Migration[6.1]
  def change
    create_table :content_creators do |t|
      t.string :first_name
      t.string :last_name
      t.string :public_unique_username
      t.string :email
      t.string :phone
      t.string :blog_url
      t.string :facebook_url
      t.string :instagram_url
      t.string :website_url
      t.text :bio
      t.string :drive_folder_url
      t.integer :university_id
      t.integer :creator_type

      t.timestamps
    end
    add_index :content_creators, :university_id
    add_index :content_creators, :creator_type
    add_index :content_creators, :email, unique: true
    add_index :content_creators, :public_unique_username, unique: true
  end
end
