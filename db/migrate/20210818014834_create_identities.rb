class CreateIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :identities do |t|
      t.integer :user_id
      t.text :external_user_id
      t.integer :provider
      t.string :email
      t.boolean :verified_email
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :picture
      t.string :locale
      t.text :access_token
      t.datetime :expires_at
      t.text :refresh_token
      t.text :scope
      t.string :token_type
      t.text :id_token

      t.timestamps
    end
    add_index :identities, :user_id
    add_index :identities, :provider
    add_index :identities, :email
    add_index :identities, [:provider, :external_user_id], unique: true
  end
end
