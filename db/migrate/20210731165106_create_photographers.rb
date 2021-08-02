class CreatePhotographers < ActiveRecord::Migration[6.1]
  def change
    create_table :photographers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :blog_url
      t.string :facebook_url
      t.string :instagram_url
      t.string :website_url
      t.text :biography
      t.string :drive_folder_url
      t.integer :university_id

      t.timestamps
    end
    add_index :photographers, :university_id
  end
end
