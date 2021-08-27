class CreateLocationCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :location_codes do |t|
      t.string :code
      t.integer :state
      t.text :description

      t.timestamps
    end
    add_index :location_codes, :code, unique: true
    add_index :location_codes, :state
  end
end
