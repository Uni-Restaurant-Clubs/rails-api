class CreateWriters < ActiveRecord::Migration[6.1]
  def change
    create_table :writers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :drive_folder_url
      t.integer :university_id

      t.timestamps
    end
    add_index :writers, :university_id
  end
end
