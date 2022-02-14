class CreatePromotionInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :promotion_infos do |t|
      t.integer :restaurant_id
      t.datetime :promotion_intro_email_sent_at
      t.datetime :restaurant_responded_at
      t.integer :restaurant_status
      t.text :notes

      t.timestamps
    end
    add_index :promotion_infos, :restaurant_id
    add_index :promotion_infos, :restaurant_status
    add_column :reviews, :promotion_intro_email_sent, :boolean, default: false
  end
end
