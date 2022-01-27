class CreateAdminUserRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_user_roles do |t|
      t.integer :admin_user_id
      t.integer :role_id

      t.timestamps
    end
    add_index :admin_user_roles, :admin_user_id
    add_index :admin_user_roles, :role_id
  end
end
