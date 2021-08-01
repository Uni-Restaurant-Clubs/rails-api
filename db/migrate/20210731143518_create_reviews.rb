class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.datetime :reviewed_at
      t.integer :writer_id
      t.integer :photographer_id
      t.integer :university_id
      t.integer :restaurant_id
      t.text :full_article
      t.text :medium_article
      t.text :small_article
      t.string :article_title

      t.timestamps
    end
    add_index :reviews, :restaurant_id
    add_index :reviews, :university_id
    add_index :reviews, :writer_id
    add_index :reviews, :photographer_id
  end
end
