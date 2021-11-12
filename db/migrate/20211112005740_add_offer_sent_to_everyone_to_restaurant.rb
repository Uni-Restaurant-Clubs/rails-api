class AddOfferSentToEveryoneToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :offer_sent_to_everyone, :boolean, default: false
    add_column :restaurants, :initial_offers_sent_to_creators, :boolean, default: false
    add_column :restaurants, :applied_for_writer, :boolean, default: false
    add_column :restaurants, :applied_for_photographer, :boolean, default: false
    add_column :restaurants, :applied_for_videographer, :boolean, default: false
    add_index :restaurants, :applied_for_videographer
    add_index :restaurants, :applied_for_writer
    add_index :restaurants, :applied_for_photographer
  end
end
