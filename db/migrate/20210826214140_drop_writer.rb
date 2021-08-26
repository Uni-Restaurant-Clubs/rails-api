class DropWriter < ActiveRecord::Migration[6.1]
  def up
    drop_table :writers
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
