class CreateCreatorReviewOffers < ActiveRecord::Migration[6.1]
  def change
    create_table :creator_review_offers do |t|
      t.datetime :responded_at
      t.boolean :option_one_response
      t.datetime :option_one
      t.datetime :option_two
      t.boolean :option_two_response
      t.datetime :option_three
      t.boolean :option_three_response
      t.integer :restaurant_id
      t.integer :content_creator_id
      t.boolean :as_writer, default: false
      t.boolean :as_photographer, default: false
      t.boolean :as_videographer, default: false
      t.string :token
      t.text :notes

      t.timestamps
    end
    add_index :creator_review_offers, :restaurant_id
    add_index :creator_review_offers, :token, unique: true
    add_index :creator_review_offers, :content_creator_id
    add_index :creator_review_offers, :as_writer
    add_index :creator_review_offers, :as_photographer
    add_index :creator_review_offers, :as_videographer
  end
end
