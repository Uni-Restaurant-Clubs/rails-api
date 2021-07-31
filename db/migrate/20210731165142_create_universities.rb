class CreateUniversities < ActiveRecord::Migration[6.1]
  def change
    create_table :universities do |t|
      t.string :name
      t.integer :school_type

      t.timestamps
    end
    add_index :universities, :school_type
  end
end
