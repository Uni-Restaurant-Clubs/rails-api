class AddOfferSentToEveryoneToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :offer_sent_to_everyone, :boolean, default: false
    add_column :restaurants, :initial_offers_sent_to_creators, :boolean, default: false
  end
end
