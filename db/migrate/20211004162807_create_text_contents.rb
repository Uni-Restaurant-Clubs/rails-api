class CreateTextContents < ActiveRecord::Migration[6.1]
  def change
    create_table :text_contents do |t|
      t.text :text
      t.integer :category
      t.string :name

      t.timestamps
    end
    add_index :text_contents, :category
    add_index :text_contents, :name
  end
end
