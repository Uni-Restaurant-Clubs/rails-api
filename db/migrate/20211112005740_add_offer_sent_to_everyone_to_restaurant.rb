class AddOfferSentToEveryoneToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :offer_sent_to_everyone, :boolean, default: false
    add_column :restaurants, :initial_offers_sent_to_creators, :boolean, default: false
    add_column :content_creators, :applied_for_writer, :boolean, default: false
    add_column :content_creators, :applied_for_photographer, :boolean, default: false
    add_column :content_creators, :applied_for_videographer, :boolean, default: false
    add_column :restaurants, :confirmed_with_restaurant_three_days_before, :boolean, default: false
    add_column :restaurants, :confirmed_with_creators_day_before, :boolean, default: false
    add_index :content_creators, :applied_for_videographer
    add_index :content_creators, :applied_for_writer
    add_index :content_creators, :applied_for_photographer
  end
end
