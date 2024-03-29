class CreateReviewHappenedConfirmations < ActiveRecord::Migration[6.1]
  def change
    create_table :review_happened_confirmations do |t|
      t.integer :content_creator_id
      t.boolean :response
      t.datetime :responded_at
      t.integer :restaurant_id
      t.string :token

      t.timestamps
    end
    add_index :review_happened_confirmations, :content_creator_id
    add_index :review_happened_confirmations, :response
    add_index :review_happened_confirmations, :restaurant_id
    add_index :review_happened_confirmations, :token, unique: true
  end
end
