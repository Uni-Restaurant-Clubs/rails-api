class DropPhotographer < ActiveRecord::Migration[6.1]
  def up
    drop_table :photographers
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
